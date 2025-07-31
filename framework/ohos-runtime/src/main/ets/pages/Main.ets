import { LogUtils, } from 'hippy'
// import { Debug } from './Debug';

@Entry
@Component
struct Main {
  private readonly TAG: string = 'RuntimeMainPage'
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @State progressValue: number = 0;
  private intervalId: number = -1

  async aboutToAppear() {
    LogUtils.d(this.TAG, 'Lifecycle: aboutToAppear');
  }

  @Builder
  PageMap(name: string) {
    if (name === "Debug") {
      // Debug();
    }
  }

  onPageShow(): void {
    LogUtils.d(this.TAG, 'Lifecycle: onPageShow');

    this.pageInfos.pushPathByName('Debug', null, false);

    this.intervalId = setInterval(() => {
      this.progressValue = this.progressValue + 20
      if (this.progressValue == 100) {
        clearInterval(this.intervalId)
        this.pageInfos.pushPathByName('Debug', null, false);
      }
    }, 500)
  }

  onPageHide(): void {
    LogUtils.d(this.TAG, 'Lifecycle: onPageHide');
  }

  aboutToDisappear(): void {
    LogUtils.d(this.TAG, 'Lifecycle: aboutToDisappear');
  }

  onBackPress(): boolean | void {
    LogUtils.d(this.TAG, 'Lifecycle: onBackPress');
    return false;
  }

  build() {
    Navigation(this.pageInfos) {
      Stack() {
        Progress({ value: 0, total: 100, type: ProgressType.Capsule })
          .width(600)
          .height(10)
          .color('#0A59F7')
          .value(this.progressValue)
      }
      .alignContent(Alignment.Center)
      .width('100%')
      .height('100%')
      .backgroundColor('#3A4251')
      .expandSafeArea()
    }
    // .navDestination(this.PageMap)
    .hideToolBar(true)
    .hideBackButton(true)
    .mode(NavigationMode.Stack)
  }
}
