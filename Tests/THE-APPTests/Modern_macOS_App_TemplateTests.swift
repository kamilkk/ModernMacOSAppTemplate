//
//  Modern_macOS_App_TemplateTests.swift
//  Modern macOS App TemplateTests
//
//  Created by Developer on $(date).
//

import XCTest
@testable import Modern_macOS_App_Template

final class ModernMacOSAppTemplateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeViewModelInitialization() throws {
        // Given
        let viewModel = HomeViewModel()

        // When
        // The view model is initialized

        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.items.count, 0)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSettingsViewModelDefaultValues() throws {
        // Given
        let viewModel = SettingsViewModel()

        // When
        // The view model is initialized

        // Then
        XCTAssertEqual(viewModel.appName, "Modern macOS App Template")
        XCTAssertTrue(viewModel.enableNotifications)
        XCTAssertFalse(viewModel.autoSave)
        XCTAssertEqual(viewModel.maxRecentItems, 10)
        XCTAssertEqual(viewModel.selectedTheme, .system)
    }

    func testAppCoordinatorInitialization() throws {
        // Given
        let coordinator = AppCoordinator()

        // When
        // The coordinator is initialized

        // Then
        XCTAssertNotNil(coordinator)
        XCTAssertEqual(coordinator.currentTab, .home)
        XCTAssertFalse(coordinator.isShowingSettings)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let viewModel = HomeViewModel()
            viewModel.loadData()
        }
    }
}
