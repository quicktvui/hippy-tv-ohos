import { NodeContent } from '@kit.ArkUI'
import {
  NativeRenderContext,
  HippyAny,
  HippyCustomComponentView,
  HippyRenderCallback,
  HippyRenderBaseView,
  HippyArray,
  HippyMap
} from 'hippy'
import { QUICKTVUI_TAG } from '../Constant';
import { HRValueUtils } from '../HRValueUtils';
import { CommonUtils } from '../utils/CommonUtils';

export class QTBaseComponentView extends HippyCustomComponentView {
  childSlot: NodeContent | null = null
  public templateView : HippyRenderBaseView | null = null;
  sid : String | null = null;
  name: String | null = null;
  public isVirtual : boolean = false;
  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  onCreateByTemplate(templateView : HippyRenderBaseView){

  }

  aboutToUpdate(){

  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    console.info(QUICKTVUI_TAG,`QTRenderBaseView setProp:${propKey},propValue:${propValue}`)
    if(propKey === 'attributes'){
      console.error(QUICKTVUI_TAG,`QTRenderBaseView attributes:${propKey},propValue:${CommonUtils.hippyAny2String(propValue)}`)
    }
    switch (propKey){
      case 'sid':
        this.sid = HRValueUtils.getString(propValue)
        if(this.sid){
          console.log(QUICKTVUI_TAG,`setSid:${this.sid},viewType:${this.viewType},tag:${this.tag}`)
        }
        return true;
      case 'name':
        this.name = HRValueUtils.getString(propValue)
        if(this.name){
          console.log(QUICKTVUI_TAG,`setName:${this.name},viewType:${this.viewType},tag:${this.tag}`)
        }
        return true;
      case "clipChildren":
        this.cssOverflow = HRValueUtils.getBoolean(propValue,true)
        return true;
      // case 'size':
      //   let size = HRValueUtils.getArray(propValue as HippyArray)
      //   this.cssWidth = size ?  size[0] as number : 0
      //   this.cssHeight = size ?  size[1] as number : 0
      //   return true;
      // case 'layout':
      //   let layout = HRValueUtils.getArray(propValue as HippyArray)
      //   this.cssPositionX = layout ?  layout[0] as number : 0
      //   this.cssPositionY = layout ?  layout[1] as number : 0
      //   this.cssWidth = layout ?  layout[2] as number : 0
      //   this.cssHeight = layout ?  layout[3] as number : 0
      //   return true;
      // case 'flexStyle':
      // case 'style':
      //   console.log(QUICKTVUI_TAG,`setStyle by :${propKey}，viewType:${this.viewType}},data:${CommonUtils.hippyMap2String(HRValueUtils.getMap(propValue))}`)
      //   this.setFlexStyle(HRValueUtils.getMap(propValue))
      //   return true;
    }
    return super.setProp(propKey, propValue)
  }

  setFlexStyle(style : HippyMap | null){
    style?.forEach((value,key)=>{
      console.log(QUICKTVUI_TAG,`setFlexStyle key:${key},value:${value} type:${typeof value}`)
      let numberValue = HRValueUtils.getNumber(value)
      this.setProp(key,value)
      // switch (key) {
      //   case 'width':
      //     if(numberValue != this.cssWidth){
      //       this.cssWidth = numberValue
      //     }
      //     break;
      //   case 'height':
      //     if(numberValue != this.cssHeight){
      //       console.log(QUICKTVUI_TAG,`setFlexStyle height:${value}`)
      //       this.cssHeight = numberValue
      //     }
      //     break ;
      //   case 'left':
      //     if(numberValue != this.cssPositionX){
      //       this.cssPositionX = numberValue
      //     }
      //     break ;
      //   case 'top':
      //     if(numberValue != this.cssPositionY){
      //       this.cssPositionY = numberValue
      //     }
      //     break ;
      //   default :
      //     console.warn(QUICKTVUI_TAG,`setStyle error 未实现的key:${key},value:${value}`)
      //     break;
      // }
    })
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {
    //
    if (method == "getEsInfo") {
      if (callback) {
        const info = new Map<string, HippyAny>()
        callback(info)
      }
    }
  }
}
