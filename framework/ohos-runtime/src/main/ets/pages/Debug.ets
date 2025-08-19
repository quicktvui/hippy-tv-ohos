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
  QTAnimationView,
  QTItemFrameView,
  QTItemFrame
} from 'quicktvui';
import { QTVideoPlayer, QTVideoPlayerView } from '../components/video/QTVideoPlayerView';
import { QTPageRouter, QTPageRouterView } from '../components/router/QTPageRouterView';
import { QTPage, QTPageView } from '../components/router/QTPageView';
import {
  QTFallbackView,
  QTFallback
} from 'quicktvui/src/main/ets/components/compat/QTFallbackView';

import {
  QTFastItem,
  QTFastItemView
} from 'quicktvui/src/main/ets/components/fastlist/QTFastItemView';
import { BusinessError } from '@kit.BasicServicesKit';
import { webSocket } from '@kit.NetworkKit';
import { util } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { uiObserver } from '@kit.ArkUI';

@Builder
export function PageDebugBuilder(name: string, param: Object) {
  Debug()
}

@Component
struct Debug {
  private TAG: string = 'RuntimeDebugPage'
  private navPathStack: NavPathStack = new NavPathStack();
  @State currentEnv: string = 'dev'
  @State versionName: string = '1.0.0'
  @State versionCode: string = '1.0.0'
  @State deviceIp: string = '192.168.80.235' //设备的IP地址
  @State debugIp: string = '192.168.80.235' // 电脑的 IP 地址
  //服务是否可用
  @State debugServerAvailable: boolean = false
  private checkHostAvailableTimerId: number = -1
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
    LogUtils.e(this.TAG, 'Lifecycle: aboutToAppear');
  }

  aboutToDisappear(): void {
    LogUtils.e(this.TAG, 'Lifecycle: aboutToDisappear');
  }

  initEngine() {
    //
    this.destroyEngine()
    //
    let params = new EngineInitParams(this.libHippy!, this.abilityContext!, this.getUIContext())
    params.coreJSAssetsPath = "vue2/vendor.ohos.js"
    params.enableArkCApi = false
    params.debugServerHost = this.debugIp + ':38989'
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

  startCheckHostAvailableTimer() {
    this.stopCheckHostAvailableTimer()
    this.checkHostAvailableTimerId = setInterval(() => {
      this.checkHostAvailable()
    }, 1000)
  }

  stopCheckHostAvailableTimer() {
    clearInterval(this.checkHostAvailableTimerId)
  }

  checkHostAvailable() {
    const uuid = util.generateRandomUUID(true)
    let defaultIpAddress =
      "ws://" + this.debugIp + ":38989/debugger-proxy?role=android_client&clientId=" + uuid;

    let ws = webSocket.createWebSocket();

    ws.on('open', (err: BusinessError, value: Object) => {
      LogUtils.i(this.TAG, `[WebSocket][open] status: ${JSON.stringify(value)}`);
      this.debugServerAvailable = true
      this.onDebugServerAvailable()
    });

    ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      LogUtils.i(this.TAG, `[WebSocket][message] message: ${value}`);
    });

    ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      LogUtils.i(this.TAG, `[WebSocket][close] code: ${value.code}, reason: ${value.reason}`);
    });

    ws.on('error', (err: BusinessError) => {
      if (this.debugServerAvailable) {
        this.showDebugServerAvailableToast(false)
      }
      this.debugServerAvailable = false
      this.startCheckHostAvailableTimer()
      LogUtils.e(this.TAG, `[WebSocket][error] ${JSON.stringify(err)}`);
    });

    ws.connect(defaultIpAddress, (err: BusinessError, value: boolean) => {
      if (!err) {
        LogUtils.i(this.TAG, `[WebSocket][connect] Connected successfully`);
      } else {
        this.debugServerAvailable = false
        this.onDebugServerAvailable()
        LogUtils.e(this.TAG, `[WebSocket][connect] Failed. Err: ${JSON.stringify(err)}`);
      }
    });
  }

  private onDebugServerAvailable() {
    setTimeout(() => {
      if (this.debugServerAvailable) {
        this.showDebugServerAvailableToast(true)
        this.stopCheckHostAvailableTimer()
      } else {
        this.showDebugServerAvailableToast(false)
      }
    }, 1000)
  }

  private showDebugServerAvailableToast(available: boolean) {
    this.getUIContext()!.getPromptAction().showToast({
      message: available ? "调试服务可用" : "调试服务不可用",
      duration: 1000,
    })
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
            Button(this.debugServerAvailable ? $r('app.string.debug_start') :
            $r('app.string.cross_mark'))
              .fontColor(Color.Black)
              .fontSize(this.debugServerAvailable ? 40 : 150)
              .fontWeight(FontWeight.Bold)
              .backgroundColor($r('app.color.debug_font_color'))
              .type(ButtonType.Circle)
              .width(300)
              .height(300)
              .onClick(() => {
                if (!this.debugServerAvailable) {
                  this.showDebugServerAvailableToast(false)
                  return
                }
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
      this.navPathStack = context.pathStack;
    })
    .onWillAppear(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onWillAppear');
      this.hippyEngine?.onLifecycleEvent("onWillAppear")
    })
    .onAttach(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onAttach');
      this.hippyEngine?.onLifecycleEvent("onAttach")
    })
    .onAppear(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onAppear');
      this.hippyEngine?.onLifecycleEvent("onAppear")
    })
    .onWillShow(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onWillShow');
      this.hippyEngine?.onLifecycleEvent("onWillShow")
    })
    .onShown(() => {
      this.hippyEngine?.onEngineResume()
      LogUtils.e(this.TAG, 'Lifecycle: onShown');
      this.hippyEngine?.onLifecycleEvent("onShown")
      //
      this.checkHostAvailable()
    })
    .onWillHide(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onWillHide');
      this.hippyEngine?.onLifecycleEvent("onWillHide")
    })
    .onHidden(() => {
      this.hippyEngine?.onEnginePause()
      LogUtils.e(this.TAG, 'Lifecycle: onHidden');
      this.hippyEngine?.onLifecycleEvent("onHidden")
    })
    .onWillDisappear(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onWillDisappear');
      this.hippyEngine?.onLifecycleEvent("onWillDisappear")
    })
    .onDetach(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onDetach');
      this.hippyEngine?.onLifecycleEvent("onDetach")
    })
    .onDisAppear(() => {
      LogUtils.e(this.TAG, 'Lifecycle: onDisAppear');
      this.hippyEngine?.onLifecycleEvent("onDisAppear")
    })
    //返回键
    .onBackPressed(() => {
      if (this.isEngineInitialized) {
        this.hippyEngine?.onBackPressed(new RuntimeDefaultBackHandler())
        return true
      } else {
        if (this.navPathStack.size() <= 1) {
          //关闭应用
          (this.abilityContext as common.UIAbilityContext).terminateSelf()
            .then(() => {
              LogUtils.d(this.TAG, 'terminateSelf success.');
            })
            .catch((err: BusinessError) => {
              LogUtils.d(this.TAG, 'terminateSelf error.' + JSON.stringify(err));
            });
        }
        return false
      }
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
  } else if ($$ instanceof QTFastListView) {
    QTFastList({
      renderView: $$ as QTFastListView,
      children: $$.children,
    })
  } else if ($$ instanceof QTTextView) {
    QTText({
      renderView: $$ as QTTextView,
      children: $$.children,
    })
  } else if ($$ instanceof QTFastItemView) {
    QTFastItem({
      renderView: $$ as QTFastItemView,
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
  } else if ($$ instanceof QTItemFrameView) {
    QTItemFrame({
      renderView: $$ as QTItemFrameView,
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
  private readonly TAG: string = "DefaultEngineListener";

  constructor(hippyEngine: HippyEngine, rootViewWrapper: HippyRootViewWrapper) {
    this.hippyEngine = hippyEngine
    this.rootViewWrapper = rootViewWrapper
  }

  onInitialized(statusCode: EngineInitStatus, msg: string): void {
    LogUtils.i(this.TAG, 'initEngine status: ' + statusCode + ' msg:' + msg);
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
  private readonly TAG: string = "DefaultModuleListener";

  onLoadCompleted(statusCode: ModuleLoadStatus, msg: string): void {
    LogUtils.i(this.TAG, 'loadModule status: ' + statusCode + ' msg:' + msg);
  }

  onJsException(exception: HippyJsException): boolean {
    LogUtils.e(this.TAG, 'loadModule onJsException: ' + exception);
    return true;
  }

  onFirstViewAdded(): void {

  }

  onFirstContentfulPaint(): void {

  }
}

