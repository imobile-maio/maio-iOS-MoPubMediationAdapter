![](https://github.com/imobile-maio/maio-iOS-SDK/blob/wiki/doc/images/logo.png)

# maio Mopub Mediation Adapter

# Get Started

## Adding Maio to your MoPub Dashboard

1. Open your MoPub dashboard, and click on the `Networks` tab.
1. Click on `New network`.
1. On the bottom of the modal, click on `Custom SDK network`.
1. Input the `Network settings` as below, and click `Next`:
    - `Network name`: `maio`
1. Click `Next` for the `Default CPM preferences`.
1. Input the `App & ad unit setup` as below, and click `Save & Close`:
    - Interstitial
        - Custom Event Class
            - `MaioInterstitial`
        - Custom Event Class Data
            ```json
            {"mediaId": "YOUR-MEDIA-ID", "zoneId": "YOUR-ZONE-ID"}
            or
            {"mediaId": "YOUR-MEDIA-ID"}
            ```
    - Rewarded Video
        - Custom Event Class
            - `MaioRewardedVideo`
        - Custom Event Class Data
            ```json
            {"mediaId": "YOUR-MEDIA-ID", "zoneId": "YOUR-ZONE-ID"}
            or
            {"mediaId": "YOUR-MEDIA-ID"}
            ```

## Implement `maio iOS SDK` and `MaioMopubAdapter` to your Project

1. Install `maio iOS SDK` to your project.
    - If you use `Cocoapods`, you can just add `pod 'MaioSDK'` to your Podfile.
    - For detailed instructions, see [`GetStarted`](https://github.com/imobile-maio/maio-iOS-SDK/wiki/Get-Started-(EN))
1. Go to the [release page](https://github.com/imobile-maio/maio-iOS-MoPubMediationAdapter/releases) and download the newest `MaioMoPubAdapter_v*.*.*.zip`.
1. Copy the contents of `MaioMoPubAdapter_v*.*.*.zip` to your project.
