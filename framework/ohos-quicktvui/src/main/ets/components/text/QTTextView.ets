
import {HippyRenderBaseView,HippyObservedArray,HRRect,HRPadding,NativeRenderContext,HippyAny,HippyRenderCallback,HIPPY_COMPONENT_KEY_PREFIX} from 'hippy'
import { TAG_QUICKTVUI } from '../../Constant';
import { HRValueUtils } from '../../HRValueUtils';
import QTRenderBaseView from '../QTRenderBaseView';
import { ViewUtils } from '../../utils/ViewUtils';
import MeasureText from '@ohos.measure';


@Observed
export class QTTextView extends QTRenderBaseView{
  cssPadding: Padding = { top: 0, right: 0, bottom: 0, left: 0 }
  maxLines: number = 10000000
  lines: number = 1
  text: string = "haha"
  fontColor: ResourceColor | null = null
  fontSize: Dimension = 20
  lineHeight: number | null = null
  // fontStyle: FontStyle = FontStyle.Normal
  // fontWeight: number | FontWeight | string = FontWeight.Normal
  // fontFamily: string | null = null

  letterSpacing: number = 0
  textAlign: TextAlign = TextAlign.Start
  ellipsisMode: EllipsisMode = EllipsisMode.END


  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    switch (propKey){
      case "lineSpacing":

        return true;
      case "textHtml":

        return true;
      case "typeface":

        return true;
      case "textSpan":

        return true;
      case "fontFamily":

        return true;
      case "gravityNumber":

        return true;
      case "gravity":
        // this. = HRValueUtils.getNumber(propValue)
        this.textAlign = ViewUtils.getTextGravity(HRValueUtils.getString(propValue))
        return true;
      case "fontSize":
        this.fontSize = HRValueUtils.getNumber(propValue)
        return true;
      case "paddingRect":

        return true;
      case "textAlignment":

        return true;
      case "textSpan":

        return true;
      case "ellipsizeMode":
        this.ellipsisMode = HRValueUtils.getNumber(propValue)
        return true;
      case "lines":
        this.maxLines = HRValueUtils.getNumber(propValue)
        return true;
      case "maxLines":
        this.maxLines = HRValueUtils.getNumber(propValue)
        return true;
      case "textColor":
        this.fontColor = HRValueUtils.getString(propValue)
        return true;
      case "lineHeight":
        this.lineHeight = HRValueUtils.getNumber(propValue)
        return true;
      case "fallbackLineSpacing":

        return true;
      case "includeFontPadding":

        return true;
      case "boldOnFocus":

        return true;
      case "gradientBackground":

        return true;
      case "select":

        return true;
      case "text":
        this.text = HRValueUtils.getString(propValue)
        // console.log(QUICKTVUI_TAG,`setText:${this.text}`)
        return true;
    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, propValue: Array<HippyAny>, callback: HippyRenderCallback | null): void {

    if(callback){
      switch (method){
        case 'getText':

          break;
      }
    }else{
      switch (method){
        case 'setText':
          this.text = HRValueUtils.getString(propValue)
          break;
        case 'setTextSize':
          this.fontSize = HRValueUtils.getNumber(propValue)
          break;
        case 'setTextColor':
          this.fontColor = HRValueUtils.getString(propValue)
          break;
        case 'textSpan':

          break;
      }
    }

  }

  setRenderViewFrame(frame: HRRect, padding: HRPadding | null): void {
    // console.error(TAG_QUICKTVUI,`QTText setRenderViewFrame width:${frame.width},height:${frame.height}`)
    super.setRenderViewFrame(frame,padding)
  }

}

@Component
export struct  QTText {
  @ObjectLink renderView: QTTextView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>


  @State textSize: SizeOptions = MeasureText.measureTextSize({
    textContent: this.renderView.text,
    fontSize: this.renderView.fontSize,
  })


  build(): void {
    Text(this.renderView.text)
      .width(this.renderView.cssWidth > 0 ? this.renderView.cssWidth : this.textSize.width)
      .height(this.renderView.cssHeight > 0 ? this.renderView.cssHeight :  this.textSize.height)
      .applyRenderViewBaseAttr(this.renderView)
      .fontSize(this.renderView.fontSize)
      .fontColor(this.renderView.fontColor)
      .lineHeight(this.renderView.lineHeight)
      .maxLines(this.renderView.maxLines)
      .textAlign(this.renderView.textAlign)
  }

  aboutToAppear(): void {
  }
}

@Extend(Text)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
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

