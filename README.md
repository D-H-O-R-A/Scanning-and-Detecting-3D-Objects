# Scanning and Detecting 3D Objects

Record spatial features of real-world objects, then use the results to find those objects in the user's environment and trigger AR content.

## Overview

Create compelling AR experiences by recognizing features in the user's environment to trigger virtual content. For example, a museum app can overlay interactive 3D visuals when the user points their device at a displayed artifact.

Using ARKit, you can enable object detection in AR apps. By providing reference objects with encoded 3D spatial features, ARKit detects corresponding real-world objects during an AR session.

### Features in This Project

- Scan and export reference object files for detection in other AR apps.
- Utilize ARObjectScanningConfiguration and ARReferenceObject for asset creation.
- Enable real-time object detection using detectionObjects in AR sessions.

## Requirements

- Xcode 10.0 or later
- iOS 12.0+
- Device with A9 or later processor (ARKit unsupported on iOS Simulator)

## Scanning Real-World Objects

This app guides users through creating high-quality reference objects for ARKit.

Steps:
1. **Prepare**: Center the object in the camera's view and tap "Next."
2. **Bounding Box**: Define the region containing the object.
3. **Scan**: Move around to capture the object from multiple angles.
4. **Adjust Origin**: Modify the reference object's anchor point and optionally load a USDZ model for testing.
5. **Test and Export**: Validate detection in various environments and save the `.arobject` file.

## Implementing Object Detection

Add reference objects to your app’s asset catalog for AR detection:

1. Open the asset catalog and create an AR resource group.
2. Drag `.arobject` files into the group.
3. Configure detection in ARWorldTrackingConfiguration:

```swift
let configuration = ARWorldTrackingConfiguration()
guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "gallery", bundle: nil) else {
    fatalError("Missing resources.")
}
configuration.detectionObjects = referenceObjects
sceneView.session.run(configuration)
```

## Best Practices

- Use detailed, textured objects for reliable detection.
- Limit objects to tabletop sizes.
- Maintain consistent lighting conditions between scanning and detection.

## Scanning Reference Objects Programmatically

Example of creating an ARReferenceObject:

```swift
let configuration = ARObjectScanningConfiguration()
configuration.planeDetection = .horizontal
sceneView.session.run(configuration, options: .resetTracking)
```

After scanning, use `createReferenceObject` to produce a reference object:

```swift
sceneView.session.createReferenceObject(transform: boundingBox.simdWorldTransform, center: float3(), extent: boundingBox.extent) { object, error in
    if let referenceObject = object {
        self.scannedReferenceObject = referenceObject.applyingTransform(origin.simdTransform)
        self.scannedReferenceObject!.name = self.scannedObject.scanName
    } else {
        print("Error: \(error?.localizedDescription ?? "Unknown error.")")
    }
}
```

Export the reference object for reuse:

```swift
do {
    try referenceObject.export(to: destinationURL)
} catch {
    print("Error exporting reference object: \(error)")
}
```
