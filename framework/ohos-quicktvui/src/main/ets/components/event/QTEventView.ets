import {
  HippyRenderBaseView,
  HippyObservedArray,
  NativeRenderContext,
  HippyAny,
  HippyRenderCallback,
  HIPPY_COMPONENT_KEY_PREFIX,
  HippyViewEvent,
  buildHippyRenderView
} from 'hippy'
import { QTBaseComponentView } from '../QTBaseComponentView'

export type QTOpCallback = (method: string, params: Array<HippyAny>,
  callback: HippyRenderCallback | null) => boolean

@Observed
export class QTEventView extends QTBaseComponentView {
  public color: string = '#ffffff';
  private callback: QTOpCallback | null = null

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setOpCallback(callback: QTOpCallback) {
    console.log("====QTEvent=======setOpCallback==============>>>>" + callback)
    this.callback = callback
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    if (propKey == "prop1") {
      // ...
      return true
    } else if (propKey == "prop2") {
      // ...
      return true
    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {
    console.log("===QTEvent========call==============>>>>" + callback)
    if (this.callback && this.callback(method, params, callback)) {
      return;
    }
  }
}

@Component
export struct QTEvent {
  @ObjectLink renderView: QTEventView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  aboutToAppear(): void {
    console.log("=====QTEvent======aboutToAppear==============>>>>" + this.renderView)
    this.renderView.setOpCallback((method: string, params: Array<HippyAny>,
      callback: HippyRenderCallback | null) => {
      if (method == "sendEsMessage") {
        // 自定义事件举例
        let event = new HippyViewEvent("onEsEvent")
        let params = new Map<string, string>()
        params.set('code', "100")
        params.set('message', "Native 发送的事件消息")
        event.send(this.renderView.ctx, this.renderView.tag, params)

        // 如果需要返回值，返回值举例
        if (callback) {
          callback("result from native")
        }
      }
      return false
    })
  }

  aboutToDisappear() {
  }

  build(): void {
    Stack() {
      Text("This is a custom component A.")
      ForEach(this.children, (item: HippyRenderBaseView) => {
        buildHippyRenderView(item, null)
      }, (item: HippyRenderBaseView) => item.tag + '')
      // 该自定义组件有Hippy子组件或其它自定义子组件时，必须加Slot来衔接子组件
      ContentSlot(this.renderView.childSlot)
    }
    .applyRenderViewBaseAttr(this.renderView)
  }
}

// base props for all components
@Extend(Stack)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({ x: $$.cssPositionX, y: $$.cssPositionY })
  .size({ width: $$.cssWidth, height: $$.cssHeight })
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as HippyRenderBaseView).cssVisibility) // must add as, otherwise the compiler has error
  .zIndex($$.cssZIndex)
  .accessibilityText($$.cssAccessibilityLabel)
  .focusable($$.cssFocusable)
  .border($$.cssBorder)
  .shadow($$.cssShadow)
  .linearGradient($$.cssLinearGradient)
  .backgroundImage($$.cssBackgroundImage)
  .backgroundImageSize($$.cssBackgroundImageSize)
  .backgroundImagePosition($$.cssBackgroundImagePosition)
  .transform($$.cssMatrix)
  .rotate($$.cssRotate)
  .scale($$.cssScale)
  .translate($$.cssTranslate)
  .hitTestBehavior($$.hitTestBehavior)
  .onClick($$.eventClick)
}

