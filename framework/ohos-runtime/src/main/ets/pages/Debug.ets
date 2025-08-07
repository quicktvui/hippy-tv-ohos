import {
  HippyEngine,
  HippyException,
  HippyRoot,
  HippyRootViewWrapper,
  HippyLibrary,
  EngineInitParams,
  createHippyEngine,
  ModuleListener,
  EngineListener,
  EngineInitStatus,
  ModuleLoadParams,
  ModuleLoadStatus,
  HippyJsException,
  HippyValue,
  HippyRenderBaseView,
} from 'hippy'
import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'
import { BackPressHandler } from 'hippy/src/main/ets/hippy_framework/HippyEngine'
import { RuntimeAPIProvider } from '../api/RuntimeAPIProvider'
// import inputDevice from '@ohos.multimodalInput.inputDevice';
// import keyEvent from '@ohos.multimodalInput.keyEvent';
import { QTAPIProvider } from 'quicktvui/src/main/ets/components/QTAPIProvider';
import {
  QTLoadingView,
  QTLoading,
  QTEventView,
  QTEvent,
  QTProgressView,
  QTProgress,
  QTQRCodeView,
  QTQRCode,
  QTWebView,
  QTWeb,
  QTSliderView,
  QTSlider,
  QTText,
  QTTextView,
  QTFastListView,
  QTFastList,
  QTDiv,
  QTDivView,
  QTFastFlex,
  QTFastFlexView,
  QTAnimation,
  QTAnimationView
} from 'quicktvui';
import { QTVideoPlayer, QTVideoPlayerView } from '../components/video/QTVideoPlayerView';
import { QTPageRouter, QTPageRouterView } from '../components/router/QTPageRouterView';
import { QTPage, QTPageView } from '../components/router/QTPageView';
import {
  QTFallbackView,
  QTFallback
} from 'quicktvui/src/main/ets/components/compat/QTFallbackView';

const TAG: string = 'RuntimeDebugPage'

@Builder
export function PageDebugBuilder(name: string, param: Object) {
  Debug()
}

@Component
struct Debug {
  pageInfos: NavPathStack = new NavPathStack();
  @State currentEnv: string = 'dev'
  @State versionName: string = '1.0.0'
  @State versionCode: string = '1.0.0'
  @State deviceIp: string = '192.168.40.57'
  @State debugIp: string = '192.168.40.32' // 这里可以通过 storage 设置
  envList: string[] = ['dev', 'test', 'prod']
  //----------------------------------------------------------------------

  @State message: string = 'Hello World';
  @StorageLink('libHippy') private libHippy: HippyLibrary | null = null
  @StorageLink('abilityContext') private abilityContext: Context | null = null
  //
  @State exception: string = ""
  hippyEngine: HippyEngine | null = null
  private rootViewWrapper: HippyRootViewWrapper = new HippyRootViewWrapper()
  @State isEngineInitialized: boolean = false

  async aboutToAppear() {
    LogUtils.e(TAG, 'Lifecycle: aboutToAppear');
    // let version = await getAppVersion()
    // this.versionName = version.name
    // this.versionCode = version.code
    // this.deviceIp = await getDeviceIp()

    // let listenerId = inputDevice.on('key', (event: keyEvent.KeyEventData) => {
    //    console.info(`按键 code: ${event.keyCode}, action: ${event.keyAction}`);
    //
    //    // 例如：方向键
    //    if (event.keyCode === 19 && event.keyAction === 0) { // KEYCODE_DPAD_UP
    //      console.log('↑ 向上键按下');
    //    }
    //  });
  }

  onPageShow(): void {
    LogUtils.e(TAG, 'Lifecycle: onPageShow');
    this.hippyEngine?.onEngineResume()
  }

  onPageHide(): void {
    LogUtils.e(TAG, 'Lifecycle: onPageHide');
    this.hippyEngine?.onEnginePause()
  }

  aboutToDisappear(): void {
    LogUtils.e(TAG, 'Lifecycle: aboutToDisappear');
  }

  initEngine() {
    //
    this.destroyEngine()
    //
    let params = new EngineInitParams(this.libHippy!, this.abilityContext!, this.getUIContext())
    params.coreJSAssetsPath = "vue2/vendor.ohos.js"
    params.enableArkCApi = false
    params.debugServerHost = this.deviceIp + ':38989'
    params.debugMode = true
    params.enableLog = true
    //自定义 module 和 component 入口
    params.providers = [
      new RuntimeAPIProvider(),
      new QTAPIProvider()
    ]
    //TODO
    params.enableArkCApi = false

    //
    this.hippyEngine = createHippyEngine(params)
    let engineListener = new DefaultEngineListener(this.hippyEngine, this.rootViewWrapper)
    this.hippyEngine.initEngine(engineListener)
    this.isEngineInitialized = true
  }

  destroyEngine() {
    let rootView = this.rootViewWrapper?.getRootView()
    if (rootView) {
      this.rootViewWrapper?.resetRootView()
      this.hippyEngine?.destroyModule(rootView.getRootId(), () => {
        this.hippyEngine?.destroyEngine()
      });
    }
    this.isEngineInitialized = false
  }

  build() {
    NavDestination() {
      Stack() {
        Row() {
          Column() {
            Text($r('app.string.debug_title'))
              .fontSize(40)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 80 })
            Column() {
              Text($r('app.string.debug_runtime_version', this.versionName, this.versionCode))
                .fontSize(20)
                .fontColor($r('app.color.debug_font_color'))
                .margin({ bottom: 15 })
              Text(`IP地址: ${this.deviceIp}`)
                .fontSize(20)
                .fontColor($r('app.color.debug_font_color'))
                .margin({ bottom: 15 })
              Text($r('app.string.debug_server_ip_address', this.debugIp))
                .fontSize(20)
                .fontColor($r('app.color.debug_font_color'))
            }.margin({ bottom: 50 })
            .alignItems(HorizontalAlign.Start)

            Text($r('app.string.debug_app_tip'))
              .fontSize(20)
              .fontColor($r('app.color.debug_font_color'))
              .margin({ bottom: 50 })
          }
          .margin({ right: 150 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)

          Column() {
            Button($r('app.string.debug_start'))
              .fontColor(Color.Black)
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
              .backgroundColor($r('app.color.debug_font_color'))
              .type(ButtonType.Circle)
              .width(300)
              .height(300)
              .onClick(() => {
                this.initEngine()
              })
          }.margin({ right: 70 })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .expandSafeArea()

        Column() {
        }.width('100%')
        .height(40)

        if (this.isEngineInitialized) {
          HippyRoot({
            hippyEngine: this.hippyEngine,
            rootViewWrapper: this.rootViewWrapper,
            onRenderException: (exception: HippyException) => {
              this.exception = `${exception.message}\n${exception.stack}`
            },
          }).layoutWeight(1)
        }
        if (this.exception) {
          Text(this.exception)
        }
      }
      .alignContent(Alignment.TopStart)
      .width('100%')
      .height('100%')
      .backgroundColor('#3A4251')
      .expandSafeArea()
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .hideToolBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .onWillAppear(() => {
      LogUtils.e(TAG, 'Lifecycle: onWillAppear');
      this.hippyEngine?.onLifecycleEvent("onWillAppear")
    })
    .onAttach(() => {
      LogUtils.e(TAG, 'Lifecycle: onAttach');
      this.hippyEngine?.onLifecycleEvent("onAttach")
    })
    .onAppear(() => {
      LogUtils.e(TAG, 'Lifecycle: onAppear');
      this.hippyEngine?.onLifecycleEvent("onAppear")
    })
    .onWillShow(() => {
      LogUtils.e(TAG, 'Lifecycle: onWillShow');
      this.hippyEngine?.onLifecycleEvent("onWillShow")
    })
    .onShown(() => {
      LogUtils.e(TAG, 'Lifecycle: onShown');
      this.hippyEngine?.onLifecycleEvent("onShown")
    })
    .onWillHide(() => {
      LogUtils.e(TAG, 'Lifecycle: onWillHide');
      this.hippyEngine?.onLifecycleEvent("onWillHide")
    })
    .onHidden(() => {
      LogUtils.e(TAG, 'Lifecycle: onHidden');
      this.hippyEngine?.onLifecycleEvent("onHidden")
    })
    .onWillDisappear(() => {
      LogUtils.e(TAG, 'Lifecycle: onWillDisappear');
      this.hippyEngine?.onLifecycleEvent("onWillDisappear")
    })
    .onDetach(() => {
      LogUtils.e(TAG, 'Lifecycle: onDetach');
      this.hippyEngine?.onLifecycleEvent("onDetach")
    })
    .onDisAppear(() => {
      LogUtils.e(TAG, 'Lifecycle: onDisAppear');
      this.hippyEngine?.onLifecycleEvent("onDisAppear")
    })
    //返回键
    .onBackPressed(() => {
      this.hippyEngine?.onBackPressed(new RuntimeDefaultBackHandler())
      return true
    })
  }
}

class RuntimeDefaultBackHandler implements BackPressHandler {
  handleBackPress(): void {
    console.log('Back button pressed');
  }
}

@Builder
function buildCustomRenderView($$: HippyRenderBaseView) {
  if ($$ instanceof QTLoadingView) {
    QTLoading({
      renderView: $$ as QTLoadingView,
      children: $$.children,
    })
  } else if ($$ instanceof QTEventView) {
    QTEvent({
      renderView: $$ as QTEventView,
      children: $$.children,
    })
  } else if ($$ instanceof QTProgressView) {
    QTProgress({
      renderView: $$ as QTProgressView,
      children: $$.children,
    })
  } else if ($$ instanceof QTQRCodeView) {
    QTQRCode({
      renderView: $$ as QTQRCodeView,
      children: $$.children,
    })
  } else if ($$ instanceof QTWebView) {
    QTWeb({
      renderView: $$ as QTWebView,
      children: $$.children,
    })
  } else if ($$ instanceof QTVideoPlayerView) {
    QTVideoPlayer({
      renderView: $$ as QTVideoPlayerView,
      children: $$.children,
    })
  } else if ($$ instanceof QTSliderView) {
    QTSlider({
      renderView: $$ as QTSliderView,
      children: $$.children,
    })
  }
  if ($$ instanceof QTFastListView) {
    QTFastList({
      renderView: $$ as QTFastListView,
      children: $$.children,
    })
  } else if ($$ instanceof QTTextView) {
    QTText({
      renderView: $$ as QTTextView,
      children: $$.children,
    })
  } else if ($$ instanceof QTDivView) {
    QTDiv({
      renderView: $$ as QTTextView,
      children: $$.children,
    })
  } else if ($$ instanceof QTPageRouterView) {
    QTPageRouter({
      renderView: $$ as QTPageRouterView,
      children: $$.children,
    })
  } else if ($$ instanceof QTAnimationView) {
    QTAnimation({
      renderView: $$ as QTAnimationView,
      children: $$.children,
    })
  }
  //页面
  else if ($$ instanceof QTPageView) {
    QTPage({
      renderView: $$ as QTPageView,
      children: $$.children,
    })
  } else if ($$ instanceof QTFastFlexView) {
    QTFastFlex({
      renderView: $$ as QTFastFlexView,
      children: $$.children,
    })
  } else {
    QTFallback({
      renderView: $$ as QTFallbackView,
      children: $$.children,
    })
  }
  //路由

}

class DefaultEngineListener implements EngineListener {
  private hippyEngine: HippyEngine
  private rootViewWrapper: HippyRootViewWrapper

  constructor(hippyEngine: HippyEngine, rootViewWrapper: HippyRootViewWrapper) {
    this.hippyEngine = hippyEngine
    this.rootViewWrapper = rootViewWrapper
  }

  onInitialized(statusCode: EngineInitStatus, msg: string): void {
    LogUtils.i(TAG, 'initEngine status: ' + statusCode + ' msg:' + msg);
    if (statusCode == EngineInitStatus.STATUS_OK) {
      let loadParams = new ModuleLoadParams(
        'vue2/index.ohos.js',
        '',
        '',
        '',
        null,
        null,
        null,
      )
      loadParams.componentName = "EsApp"
      loadParams.codeCacheTag = "EsApp"
      loadParams.jsParams = new Map<string, HippyValue>()
      loadParams.jsParams.set(
        "msgFromNative",
        "Hi js developer, I come from ohos native code!"
      )
      loadParams.wrappedCustomRenderViewBuilder = wrapBuilder(buildCustomRenderView)
      let moduleListener = new DefaultModuleListener()
      let rootView = this.hippyEngine.loadModuleWithListener(loadParams, moduleListener)
      if (rootView) {
        this.rootViewWrapper.setRootView(rootView)
      }
    }
  }
}

class DefaultModuleListener implements ModuleListener {
  onLoadCompleted(statusCode: ModuleLoadStatus, msg: string): void {
    LogUtils.i(TAG, 'loadModule status: ' + statusCode + ' msg:' + msg);
  }

  onJsException(exception: HippyJsException): boolean {
    LogUtils.e(TAG, 'loadModule onJsException: ' + exception);
    return true;
  }

  onFirstViewAdded(): void {

  }

  onFirstContentfulPaint(): void {

  }
}

