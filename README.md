# Modern macOS App Template

A comprehensive, production-ready macOS app template built with SwiftUI, following modern iOS development best practices and industry standards.

## 🏗️ Architecture

This template implements the **MVVM+C (Model-View-ViewModel + Coordinator)** architectural pattern, providing:

- ✅ Clear separation of concerns
- ✅ Testable business logic
- ✅ Scalable navigation flow
- ✅ Maintainable codebase

### Architecture Overview

```
Sources/
├── App/                    # App entry point and main coordinator
├── Core/                   # Core utilities and services
│   ├── Models/            # Data models
│   ├── Services/          # Business services (Network, Data, etc.)
│   ├── Utilities/         # Helper utilities and constants
│   └── Extensions/        # Swift extensions
├── Features/              # Feature modules (MVVM+C structure)
│   ├── Home/             # Home feature
│   │   ├── Views/        # SwiftUI views
│   │   ├── ViewModels/   # Business logic
│   │   └── Coordinators/ # Navigation logic
│   └── Settings/         # Settings feature
└── UI/                   # Shared UI components
    ├── Components/       # Reusable UI components
    └── Styles/          # Design system and styles
```

## 🛠️ Development Tools

### Included Tools

- **SwiftGen**: Type-safe resource generation
- **SwiftLint**: Code quality and style enforcement
- **Swift Format**: Automatic code formatting
- **Swift Package Manager**: Dependency management

### Tool Configuration

All tools are pre-configured with industry best practices:

- `.swiftlint.yml` - Comprehensive linting rules
- `.swift-format` - Code formatting configuration
- `swiftgen.yml` - Resource generation settings
- `Package.swift` - Dependencies and build configuration

## 🚀 Getting Started

### Prerequisites

- macOS 13.0+ (Ventura)
- Xcode 15.0+
- Swift 5.9+

### Installation

1. **Download and extract** the template
2. **Rename the project** to your app name
3. **Run the setup script**:
   ```bash
   ./Scripts/build.sh
   ```
4. **Open in Xcode**:
   ```bash
   open Package.swift
   ```

### Build Scripts

The template includes several build scripts in the `Scripts/` directory:

```bash
# Format code, run linting, and build
./Scripts/build.sh

# Generate resources with SwiftGen
./Scripts/swiftgen.sh

# Format code with swift-format
./Scripts/swift-format.sh

# Run SwiftLint for code quality
./Scripts/swiftlint.sh
```

## 📱 Features

### Core Features

- ✅ **Modern SwiftUI UI** with native macOS design
- ✅ **MVVM+C Architecture** for scalable code organization
- ✅ **Type-safe Resources** with SwiftGen integration
- ✅ **Comprehensive Settings** with user preferences
- ✅ **Network Layer** with async/await support
- ✅ **Localization Support** for multiple languages
- ✅ **Dark/Light Mode** with system theme support
- ✅ **Accessibility** compliant components

### UI Components

The template includes a comprehensive UI component library:

- **LoadingButton** - Button with loading state
- **SearchBar** - Customizable search interface
- **StatusBadge** - Status indicator component
- **EmptyStateView** - Placeholder for empty states
- **SectionHeader** - Consistent section headers
- **ToastView** - Toast notifications

### Styling System

- **AppStyles.swift** - Centralized design system
- **Color Extensions** - Hex color support and system colors
- **Font Extensions** - Typography scale
- **Custom Button Styles** - Primary/Secondary button styles
- **View Modifiers** - Reusable view modifications

## 🧪 Testing

The template includes testing infrastructure:

```
Tests/
├── Modern-macOS-App-TemplateTests/     # Unit tests
└── Modern-macOS-App-TemplateUITests/   # UI tests
```

### Testing Libraries

- **XCTest** - Native testing framework
- **SnapshotTesting** - UI snapshot testing

## 📦 Dependencies

The template uses carefully selected, production-ready dependencies:

### Development Tools
- **SwiftLint** (0.54.0+) - Code linting
- **SwiftGen** (6.6.0+) - Resource generation
- **Swift Format** (508.0.1+) - Code formatting

### Architecture & Utilities
- **Composable Architecture** (1.0.0+) - State management (optional)
- **Alamofire** (5.8.0+) - Networking
- **Kingfisher** (7.10.0+) - Image loading and caching

### Testing
- **SnapshotTesting** (1.15.0+) - UI snapshot testing

## 🎨 Customization

### Adapting the Template

1. **Update App Information**:
   - Modify `AppConstants.swift` for app-specific values
   - Update localization strings in `Localizable.strings`
   - Replace placeholder URLs and identifiers

2. **Customize UI**:
   - Modify colors in `Colors.xcassets`
   - Update fonts and styles in `AppStyles.swift`
   - Add your app icon and assets

3. **Add Features**:
   - Create new feature modules following the MVVM+C pattern
   - Add coordinators for navigation logic
   - Implement view models for business logic

### Project Structure Guidelines

- **Features**: Organize by feature, not by file type
- **Coordinators**: Handle navigation and flow logic
- **ViewModels**: Contain business logic and state
- **Views**: Keep as simple and declarative as possible
- **Services**: Implement data access and external APIs

## 🔧 Configuration

### SwiftGen

Resources are automatically generated from:
- `Assets.xcassets` → `Assets+Generated.swift`
- `Colors.xcassets` → `Colors+Generated.swift`
- `Localizable.strings` → `Strings+Generated.swift`
- Font files → `Fonts+Generated.swift`

### SwiftLint

The configuration includes:
- 50+ enabled rules for code quality
- Customized rules for SwiftUI development
- Automatic formatting suggestions
- Performance and readability checks

### Swift Format

Configured for:
- 2-space indentation
- 120 character line length
- SwiftUI-friendly formatting
- Consistent code style

## 📚 Documentation

### Code Documentation

- All public APIs are documented
- Complex business logic includes inline comments
- Architecture decisions are explained
- Setup and configuration instructions included

### File Headers

All files include standardized headers with:
- File name and purpose
- Project name
- Creation date
- Copyright information

## 🤝 Contributing

### Code Style

- Follow the included SwiftLint configuration
- Use the provided Swift Format settings
- Write tests for new features
- Document public APIs

### Git Workflow

- Use feature branches for new functionality
- Write descriptive commit messages
- Include tests with pull requests
- Update documentation as needed

## 📄 License

This template is provided as-is for educational and commercial use. Modify and distribute as needed for your projects.

## 🙋‍♂️ Support

For questions and support:

- **Documentation**: Check the inline code documentation
- **Issues**: Review common setup issues below
- **Examples**: See the included sample implementations

### Common Issues

1. **SwiftGen not found**: Install via Homebrew: `brew install swiftgen`
2. **SwiftLint errors**: Run `./Scripts/swiftlint.sh` to see specific issues
3. **Build failures**: Ensure Xcode 15+ and macOS 13+ are installed

## 🎯 Next Steps

After setting up the template:

1. **Customize branding** and app information
2. **Add your features** following the established patterns
3. **Configure backend services** and API endpoints
4. **Set up CI/CD** pipelines for automated building and testing
5. **Add app analytics** and crash reporting
6. **Implement deep linking** and URL schemes
7. **Add user authentication** if required
8. **Configure app store metadata** for distribution

---

**Happy coding! 🎉**

Built with ❤️ for the Swift community.
