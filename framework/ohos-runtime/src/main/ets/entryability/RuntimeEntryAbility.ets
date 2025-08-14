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
  //
  private runtimeNavPathStack: NavPathStack = new NavPathStack()

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppStorage.setOrCreate("RuntimeNavPathStack", this.runtimeNavPathStack)
    AppStorage.setOrCreate("libHippy", libHippy)
    AppStorage.setOrCreate("abilityContext", this.context)

    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    LogUtils.i(this.TAG, `onCreate: want: uri: ${want?.uri}  launchParam: ${launchParam}`)
    //
    this.launch(want, launchParam, false)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    LogUtils.i(this.TAG,
      `onNewWant: want: uri: ${want.uri}  launchParam: ${JSON.stringify(launchParam)}`)
    this.launch(want, launchParam, true)
  }

  /**
   *
   * @param want
   * @param launchParam
   * @param onNewWant
   */
  private launch(want: Want, launchParam: AbilityConstant.LaunchParam, onNewWant: boolean) {
    let uri = want?.uri;
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
    //TODO
    this.runtimeNavPathStack?.pushPathByName('Animation', null, false);
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
