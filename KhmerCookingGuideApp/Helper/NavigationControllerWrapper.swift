//
//  NavigationControllerWrapper.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 12/12/24.
//
import SwiftUI
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct NavigationControllerWrapper<Content: View>: UIViewControllerRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let hostingController = UIHostingController(rootView: content)
        let navigationController = UINavigationController(rootViewController: hostingController)

        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.isHidden = true
        hostingController.view.backgroundColor = .clear

        // Set the delegate for the pop gesture
        navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator

        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context _: Context) {
        if let hostingController = uiViewController.viewControllers.first as? UIHostingController<Content> {
            hostingController.rootView = content
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let content: Any

        init(content: Any) {
            self.content = content
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            // Get the navigation controller from the gesture's view hierarchy
            if let navigationController = gestureRecognizer.view?.window?.rootViewController as? UINavigationController,
               let topViewController = navigationController.topViewController as? UIHostingController<Content>
            {
                // Check if the top view is LoginView to prevent gesture
                if topViewController.rootView is AuthenticationView {
                    return false
                }
            }
            return true
        }
    }
}
