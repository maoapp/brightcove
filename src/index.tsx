import { requireNativeComponent, Platform } from 'react-native';

const NativeModule = Platform.OS === 'ios' ? requireNativeComponent('RNTBrightcoveView') : requireNativeComponent('BrightcovePlayer');

export default NativeModule;
