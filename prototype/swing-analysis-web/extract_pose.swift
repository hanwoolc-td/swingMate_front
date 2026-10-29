import AVFoundation
import CoreGraphics
import Foundation
import Vision

struct JointPayload: Codable {
    let x: Double
    let y: Double
    let confidence: Double
}

struct PoseFrame: Codable {
    let t: Double
    let joints: [String: JointPayload]
}

struct PoseOutput: Codable {
    let app: String
    let version: Int
    let videoName: String
    let sampleFPS: Double
    let duration: Double
    let frames: [PoseFrame]
}

guard CommandLine.arguments.count >= 3 else {
    FileHandle.standardError.write(Data("usage: swift extract_pose.swift INPUT.mp4 OUTPUT.json [fps]\n".utf8))
    exit(2)
}

let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
let sampleFPS = CommandLine.arguments.count >= 4 ? (Double(CommandLine.arguments[3]) ?? 15) : 15

let joints: [(String, VNHumanBodyPoseObservation.JointName)] = [
    ("nose", .nose),
    ("neck", .neck),
    ("root", .root),
    ("leftShoulder", .leftShoulder),
    ("leftElbow", .leftElbow),
    ("leftWrist", .leftWrist),
    ("rightShoulder", .rightShoulder),
    ("rightElbow", .rightElbow),
    ("rightWrist", .rightWrist),
    ("leftHip", .leftHip),
    ("leftKnee", .leftKnee),
    ("leftAnkle", .leftAnkle),
    ("rightHip", .rightHip),
    ("rightKnee", .rightKnee),
    ("rightAnkle", .rightAnkle),
]

var frames: [PoseFrame] = []
var isDirectory: ObjCBool = false
FileManager.default.fileExists(atPath: inputURL.path, isDirectory: &isDirectory)

func detectPose(handler: VNImageRequestHandler, time: Double) throws -> PoseFrame? {
    let request = VNDetectHumanBodyPoseRequest()
    try handler.perform([request])
    guard let observation = request.results?.first else { return nil }
    let recognized = try observation.recognizedPoints(.all)
    var payload: [String: JointPayload] = [:]

    for (name, joint) in joints {
        guard let point = recognized[joint], point.confidence >= 0.1 else { continue }
        payload[name] = JointPayload(
            x: Double(point.location.x),
            y: 1.0 - Double(point.location.y),
            confidence: Double(point.confidence)
        )
    }
    return payload.isEmpty ? nil : PoseFrame(t: time, joints: payload)
}

var duration: Double = 0
var frameCount: Int = 0

if isDirectory.boolValue {
    let imageURLs = try FileManager.default.contentsOfDirectory(
        at: inputURL,
        includingPropertiesForKeys: nil
    ).filter { ["png", "jpg", "jpeg"].contains($0.pathExtension.lowercased()) }
     .sorted { $0.lastPathComponent < $1.lastPathComponent }

    frameCount = imageURLs.count
    duration = frameCount > 1 ? Double(frameCount - 1) / sampleFPS : 0
    for (index, imageURL) in imageURLs.enumerated() {
        do {
            let handler = VNImageRequestHandler(url: imageURL, orientation: .up)
            if let frame = try detectPose(handler: handler, time: Double(index) / sampleFPS) {
                frames.append(frame)
            }
        } catch {
            FileHandle.standardError.write(Data("frame \(index) failed: \(error)\n".utf8))
        }
    }
} else {
    let asset = AVURLAsset(url: inputURL)
    duration = try await asset.load(.duration).seconds
    guard duration.isFinite, duration > 0 else {
        throw NSError(domain: "GolfPose", code: 1, userInfo: [NSLocalizedDescriptionKey: "invalid video duration"])
    }
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    generator.requestedTimeToleranceBefore = .zero
    generator.requestedTimeToleranceAfter = .zero
    frameCount = Int(floor(duration * sampleFPS)) + 1

    for index in 0..<frameCount {
        let requestedSeconds = min(Double(index) / sampleFPS, duration)
        let requested = CMTime(seconds: requestedSeconds, preferredTimescale: 600)
        var actual = CMTime.zero
        do {
            let image = try generator.copyCGImage(at: requested, actualTime: &actual)
            let handler = VNImageRequestHandler(cgImage: image, orientation: .up)
            if let frame = try detectPose(handler: handler, time: actual.seconds) {
                frames.append(frame)
            }
        } catch {
            FileHandle.standardError.write(Data("frame \(index) failed: \(error)\n".utf8))
        }
    }
}

let output = PoseOutput(
    app: "golf-swing-pose",
    version: 1,
    videoName: inputURL.lastPathComponent,
    sampleFPS: sampleFPS,
    duration: duration,
    frames: frames
)
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
try encoder.encode(output).write(to: outputURL, options: .atomic)
print("wrote \(frames.count)/\(frameCount) pose frames to \(outputURL.path)")
