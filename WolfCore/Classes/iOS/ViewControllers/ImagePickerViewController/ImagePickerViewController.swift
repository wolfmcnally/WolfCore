//
//  ImagePickerViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/21/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

//
// NOTE:
//
// To use this, these keys must be provided in Info.plist along with purpose strings.
//
// NSCameraUsageDescription
// NSPhotoLibraryUsageDescription
//
// https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW17
//

private let movieRawType: NSString = kUTTypeMovie

public typealias ImagePickerSuccessAction = (UIImage?) -> Void

public class ImagePickerViewController: UIImagePickerController {
    private var successAction: ImagePickerSuccessAction!
    private var cancelAction: Block?
    fileprivate var allowsCropping: Bool = false

    public static func present(from presentingViewController: UIViewController, sourceView: UIView, requestedMediaTypes: [ImagePickerViewController.MediaType], allowsCropping: Bool, cancel cancelAction: Block? = nil, remove removeAction: Block?, success successAction: @escaping ImagePickerSuccessAction) {
        var actions = [
            AlertAction(title: "Take Photo"¶, identifier: "takePhoto") { _ in
                if DeviceAccess.checkCameraAuthorized(from: presentingViewController) {
                    ImagePickerViewController.present(fromViewController: presentingViewController, sourceType: .camera, requestedMediaTypes: requestedMediaTypes, allowsCropping: allowsCropping, cancel: cancelAction, success: successAction)
                }
            },
            AlertAction(title: "Photo Library"¶, style: .default, identifier: "choosePhoto") { _ in
                if DeviceAccess.checkPhotoLibraryAuthorized(from: presentingViewController) {
                    ImagePickerViewController.present(fromViewController: presentingViewController, sourceType: .photoLibrary, requestedMediaTypes: requestedMediaTypes, allowsCropping: allowsCropping, cancel: cancelAction, success: successAction)
                }
            }
        ]

        if let removeAction = removeAction {
            let a = AlertAction(title: "Remove"¶, style: .destructive, identifier: "remove") { _ in
                removeAction()
            }
            actions.append(a)
        }

        actions.append(
            AlertAction.newCancelAction { _ in
                cancelAction?()
            }
        )
        presentingViewController.presentSheet(identifier: "imagePickerMode", popoverSourceView: sourceView, actions: actions)
    }

    public enum MediaType: String {
        case image = "public.image" // kUTTypeImage
        case movie = "public.movie" // kUTTypeMovie
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        _setup()
    }

    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        _setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _setup()
    }

    private func _setup() {
        logInfo("init \(self)", group: .viewControllerLifecycle)
        setup()
    }

    public func setup() {
    }

    deinit {
        logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    public static func present(fromViewController presentingViewController: UIViewController, sourceType: UIImagePickerControllerSourceType, requestedMediaTypes: [MediaType], allowsCropping: Bool, cancel cancelAction: Block? = nil, success successAction: @escaping ImagePickerSuccessAction) {

        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            let message: String
            switch sourceType {
            case .photoLibrary, .savedPhotosAlbum:
                message = "The photo library is unavailable."¶
            case .camera:
                message = isSimulator ? "The simulator cannot take photos." : "There is no camera available on this device."¶
            }
            presentingViewController.presentOKAlert(withMessage: message, identifier: "notImagePickerCapable")
            return
        }

        var requestedMediaTypes = requestedMediaTypes
        if sourceType == .camera && requestedMediaTypes.count > 1 {
            requestedMediaTypes = [ requestedMediaTypes.first! ]
        }

        let availableMediaRawTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        let availableMediaTypes = availableMediaRawTypes.flatMap { MediaType(rawValue: $0) }
        let effectiveMediaTypes = Set(availableMediaTypes).intersection(Set(requestedMediaTypes))
        guard !effectiveMediaTypes.isEmpty else {
            presentingViewController.presentOKAlert(withMessage: "No requested media types are available."¶, identifier: "notMediaTypeCapable")
            return
        }

        let controller = ImagePickerViewController()
        controller.mediaTypes = effectiveMediaTypes.map { $0.rawValue }
        controller.sourceType = sourceType
        controller.delegate = controller
        controller.successAction = successAction
        controller.cancelAction = cancelAction
        controller.allowsCropping = allowsCropping

        presentingViewController.present(controller, animated: true, completion: nil)
    }

    fileprivate func success(withImage image: UIImage) {
        self.successAction(image)
        dismiss()
    }

    fileprivate func cancel() {
        dismiss {
            self.cancelAction?()
        }
    }

    fileprivate func forward(to cropper: ImageCropper) {
        pushViewController(cropper.cropperViewController, animated: true)
    }

    fileprivate func back() {
        popViewController(animated: true)
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = (info[UIImagePickerControllerEditedImage] as? UIImage) ?? info[UIImagePickerControllerOriginalImage] as? UIImage else {
            logError("Image not retrieved from picker.")
            cancel()
            return
        }

        if allowsCropping {
            let cropper = newImageCropper(with: image)
            cropper.avoidEmptySpaceAroundImage = true
            cropper.onDidCancel = { [unowned self] in
                self.cancel()
            }
            cropper.onDidCrop = { [unowned self] (croppedImage: UIImage, _) in
                self.success(withImage: croppedImage)
            }
            forward(to: cropper)
        } else {
            success(withImage: image)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cancel()
    }
}

extension ImagePickerViewController: UINavigationControllerDelegate {
}
