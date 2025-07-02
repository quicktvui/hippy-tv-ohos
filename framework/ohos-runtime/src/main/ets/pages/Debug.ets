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

const TAG: string = 'RuntimeDebug'

@Entry
@Component
struct Debug {
  @State currentEnv: string = 'dev'
  @State versionName: string = '1.0.0'
  @State versionCode: string = '1.0.0'
  @State deviceIp: string = '192.168.0.88'
  @State debugIp: string = '192.168.0.88' // 这里可以通过 storage 设置
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
    // let version = await getAppVersion()
    // this.versionName = version.name
    // this.versionCode = version.code
    // this.deviceIp = await getDeviceIp()
  }

  onBackPress(): boolean | void {
    const ret = this.isEngineInitialized;
    if (this.isEngineInitialized) {
      this.destroyEngine()
    }
    return ret;
  }

  onPageShow(): void {
    this.hippyEngine?.onEngineResume()
  }

  onPageHide(): void {
    this.hippyEngine?.onEnginePause()
  }

  initEngine() {
    //
    this.destroyEngine()
    //
    let params = new EngineInitParams(this.libHippy!, this.abilityContext!, this.getUIContext())
    params.coreJSAssetsPath = "vue2/vendor.ohos.js"
    params.enableArkCApi = true
    params.debugServerHost = '192.168.40.40:38989'
    params.debugMode = true
    params.enableLog = true

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
}


@Builder
function buildCustomRenderView($$: HippyRenderBaseView) {
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

