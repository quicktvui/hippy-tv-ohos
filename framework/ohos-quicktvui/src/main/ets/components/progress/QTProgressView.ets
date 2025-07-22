import {
  HippyRenderBaseView,
  HippyObservedArray,
  NativeRenderContext,
  HippyAny,
  HIPPY_COMPONENT_KEY_PREFIX,
  HippyCustomComponentView,
} from 'hippy'


@Observed
export class QTProgressView extends HippyCustomComponentView {
  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    return super.setProp(propKey, propValue)
  }
}

@Component
export struct QTProgress {
  @ObjectLink renderView: QTProgressView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  aboutToAppear() {
    if (this.renderView.eventAttachedToWindow) {
      this.renderView.eventAttachedToWindow()
    }
  }

  aboutToDisappear() {
    if (this.renderView.eventDetachedFromWindow) {
      this.renderView.eventDetachedFromWindow()
    }
  }

  build() {
    Progress({ value: 90, total: 100, type: ProgressType.Linear })
      .style({ strokeWidth: 5, enableSmoothEffect: false })// 设置strokeWidth进度条宽度为15.0vp
      .applyRenderViewBaseAttr(this.renderView)
      .color(Color.Pink)// 进度条前景色为灰色
      .backgroundColor(Color.Green)
  }
}

// base props for all components
@Extend(Progress)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  // .position({ x: $$.cssPositionX, y: $$.cssPositionY })
  .size({ width: $$.cssWidth, height: $$.cssHeight })
  // .opacity($$.cssOpacity)
  // .clip($$.cssOverflow)
  // .visibility(($$ as HippyRenderBaseView).cssVisibility) // must add as, otherwise the compiler has error
  // .zIndex($$.cssZIndex)
  // .accessibilityText($$.cssAccessibilityLabel)
  // .focusable($$.cssFocusable)
  // .border($$.cssBorder)
  // .shadow($$.cssShadow)
  // .linearGradient($$.cssLinearGradient)
  // .backgroundImage($$.cssBackgroundImage)
  // .backgroundImageSize($$.cssBackgroundImageSize)
  // .backgroundImagePosition($$.cssBackgroundImagePosition)
  // .transform($$.cssMatrix)
  // .rotate($$.cssRotate)
  // .scale($$.cssScale)
  // .translate($$.cssTranslate)
  // .hitTestBehavior($$.hitTestBehavior)
  // .onClick($$.eventClick)
}
