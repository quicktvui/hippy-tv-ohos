import {
  HippyRenderBaseView,
  HippyObservedArray,
  NativeRenderContext,
  HippyAny,
  HIPPY_COMPONENT_KEY_PREFIX,
  HippyCustomComponentView,
} from 'hippy'


// import { scanCore, generateBarcode } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Observed
export class QTQRCodeView extends HippyCustomComponentView {
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
export struct QTQRCode {
  @ObjectLink renderView: QTQRCodeView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  aboutToAppear() {
    // scanCore, generateBarcod

    // let content: string = 'huawei';
    // let options: generateBarcode.CreateOptions = {
    //   scanType: scanCore.ScanType.QR_CODE,
    //   height: 400,
    //   width: 400
    // }
  }

  aboutToDisappear() {

  }


  build() {
    Image('images/view.jpg')
      .width(200)
    // Canvas(this.context)
    //   .applyRenderViewBaseAttr(this.renderView)
    //   .onReady(() => {
    //     this.draw();
    //   })
  }
}

// base props for all components
@Extend(Image)
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
