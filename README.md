# react-native-brightcove

react native module to support bright code player

- **iOS Platform:**
  1. Update Podfile config:
  ```
  plugin 'cocoapods-user-defined-build-types'
  enable_user_defined_build_types!

  pod 'Brightcove-Player-Core', :build_type => :dynamic_framework
  ```
  2. Install Pods
  ```sh
  gem install cocoapods-user-defined-build-types

  cd ios && pod install && cd .. # CocoaPods on iOS needs this extra step
  ```
## Installation

```sh
npm install react-native-brightcove
```

## Usage

```js
import Brightcove from "react-native-brightcove";

// ...

const result = await Brightcove.multiply(3, 7);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
