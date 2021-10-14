import React from 'react';
import { View } from 'react-native'


import BrightCove from 'react-native-brightcove';

export default function App() {

  return (<View style={{flex: 1}}><BrightCove 
    policyKey="BCpkADawqM0T8lW3nMChuAbrcunBBHmh4YkNl5e6ZrKQwPiK_Y83RAOF4DP5tyBF_ONBVgrEjqW6fbV0nKRuHvjRU3E8jdT9WMTOXfJODoPML6NUDCYTwTHxtNlr5YdyGYaCPLhMUZ3Xu61L" 
    videoId="6140448705001"
    accountId="5434391461001" 
    style={{flex:1}}/></View>);
}
