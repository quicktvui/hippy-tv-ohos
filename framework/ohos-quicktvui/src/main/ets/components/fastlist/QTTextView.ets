
import {HippyRenderBaseView,HippyObservedArray,HRDiv,NativeRenderContext,HippyAny,HippyRenderCallback} from 'hippy'
import QTRenderBaseView from '../QTRenderBaseView';


@Observed
export class QTTextView extends QTRenderBaseView{

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

        return true;
      case "fontSize":

        return true;
      case "paddingRect":

        return true;
      case "textAlignment":

        return true;
      case "textSpan":

        return true;
      case "ellipsizeMode":

        return true;
      case "lines":

        return true;
      case "maxLines":

        return true;
      case "textColor":

        return true;
      case "lineHeight":

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

        return true;
    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {

    if(callback){
      switch (method){
        case 'getText':

          break;
      }
    }else{
      switch (method){
        case 'setText':

          break;
        case 'setTextSize':

          break;
        case 'setTextColor':

          break;
        case 'textSpan':

          break;
      }
    }

  }

}

@Component
export struct  QTText {
  @ObjectLink renderView: QTTextView
  @ObjectLink children: HippyObservedArray<QTRenderBaseView>

  build(): void {
    HRDiv({
      renderView: this.renderView,
      children:  this.children
    }).onClick(()=>{

    })
  }

  aboutToAppear(): void {

  }
}

