import {PixelUtil,HRRect,HippyRenderBaseView,HRPadding,HippyAny,HippyMap} from 'hippy'
import { TAG_QUICKTVUI } from '../Constant';
import {display} from '@kit.ArkUI'
import { HRValueUtils } from '../HRValueUtils';


export class QTPixelUtil{
  public static DEV_WIDTH = 1920.0;

  public static dev2Vp(value: number) : number{
    let screenWidthDP = PixelUtil.px2dp(display.getDefaultDisplaySync().width)
    let scalePx = 2560 / QTPixelUtil.DEV_WIDTH
    // console.log(QUICKTVUI_TAG,`dp2px getDensityScale :${PixelUtil.getDensityScale()},getDensity:${PixelUtil.getDensity()},scalePx:${scalePx}`)
    //Fixme 这里暂未实现适配
    return (value ) ;
  }

  public static vp2Vp(value: number): number{
    return value
  }

  public static devRect2Vp(rect : HRRect){
    return new HRRect(QTPixelUtil.dev2Vp(rect.x),QTPixelUtil.dev2Vp(rect.y),QTPixelUtil.dev2Vp(rect.width),QTPixelUtil.dev2Vp(rect.height))
  }

  public static setScaledRenderViewFrame(view : HippyRenderBaseView | null, rect : HRRect | null, padding : HRPadding | null){
    if(view && rect){
      view.setRenderViewFrame(QTPixelUtil.devRect2Vp(rect),padding)
    }
  }

  public static getDimensionValue(value : HippyAny) : number{
    // return QTPixelUtil.dev2Vp(HRValueUtils.getNumber(value))
    return HRValueUtils.getNumber(value)
  }

  public static dev2VpStyle(style : HippyMap) : HippyMap{
    let result = new Map<string,HippyAny>()
    style.forEach((value,key)=>{
        switch (key){
        }
    })
    return result
  }
}
