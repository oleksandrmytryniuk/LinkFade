//
//  NewPostViewController.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 14.12.2022.
//

import UIKit
import PhotosUI

final class NewPostViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    
    var service: NewPostServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor.separator.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service?.addListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        service?.removeListener()
    }
    
    @IBAction private func selectImage() {
        var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction private func addNewPost() {
        if imageView.image?.isSymbolImage == false, let data = imageView.image?.pngData() {
            service?.savePost(text: textView.text, imageData: data) { [weak self] error in
                if error != nil {
                    self?.showStorageErrorAlert()
                    return
                }
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showStorageErrorAlert() {
        let alert = AlertBuilder()
            .message("Помилка збереження даних")
            .action(title: "OK") { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .make()
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 255
    }
}

// MARK: - PHPickerViewControllerDelegate

extension NewPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.map({ $0.itemProvider }).first
        if let itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if error == nil, let image = object as? UIImage {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}
