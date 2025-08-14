import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { url } from '@kit.ArkTS';
import libHippy from 'libhippy.so'
import {
  LogUtils
} from 'hippy';

const DOMAIN = 0x0000;

export default class RuntimeEntryAbility extends UIAbility {
  public readonly TAG: string = 'RuntimeEntryAbility'

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    let uri = want?.uri;
    LogUtils.i(this.TAG, `onCreate: want: uri: ${uri}  launchParam: ${launchParam}`)
    if (uri) {
      // let urlObject = url.URL.parseURL(want?.uri);
      // let action = urlObject.params.get('action');
      // 例如，当action为showall时，展示所有的节目。
      // if (action === "showall") {
      //   // ...
      // }
    }
    AppStorage.setOrCreate("libHippy", libHippy)
    AppStorage.setOrCreate("abilityContext", this.context)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let uri = want?.uri;
    LogUtils.i(this.TAG, `onNewWant: want: uri: ${uri}  launchParam: ${JSON.stringify(launchParam)}`)
    if (uri) {
      let urlObject = url.URL.parseURL(want?.uri);
      let pkg = urlObject.params.get('pkg');
      let from = urlObject.params.get('from');
      LogUtils.i(this.TAG, `onNewWant: want: uri: pkg: ${pkg} from: ${from}`)
      // let action = urlObject.params.get('action');
      // 例如，当action为showall时，展示所有的节目。
      // if (action === "showall") {
      //   // ...
      // }
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Main', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s',
          JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
