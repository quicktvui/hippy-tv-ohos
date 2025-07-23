import {
  HippyRenderBaseView,
  HippyObservedArray,
  NativeRenderContext,
  HippyAny,
  HIPPY_COMPONENT_KEY_PREFIX,
  HippyCustomComponentView,
} from 'hippy'


@Observed
export class QTAVPlayerView extends HippyCustomComponentView {
  public color: string = '#ffffff';

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    if (propKey === 'color') {
      this.color = propValue as string;
      return true;
    }
    return super.setProp(propKey, propValue)
  }
}

@Component
export struct QTAVPlayer {
  @ObjectLink renderView: QTAVPlayerView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  aboutToAppear() {

  }

  aboutToDisappear() {

  }

  build() {
    Stack().applyRenderViewBaseAttr(this.renderView)
  }
}

// base props for all components
@Extend(Stack)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({ x: $$.cssPositionX, y: $$.cssPositionY })
  .size({
    width:
    typeof $$.cssWidth === 'number'
      ? $$.cssWidth
      : parseFloat($$.cssWidth) || 100,
    height:
    typeof $$.cssHeight === 'number'
      ? $$.cssHeight
      : parseFloat($$.cssHeight) || 100,
  })
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as HippyRenderBaseView).cssVisibility)
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
