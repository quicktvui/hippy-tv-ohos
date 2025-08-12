import {PixelUtil,HRRect,HippyRenderBaseView,HRPadding} from 'hippy'
import { QUICKTVUI_TAG } from '../Constant';
import {display} from '@kit.ArkUI'
export class QTPixelUtil{
  public static DEV_WIDTH = 1920.0;

  public static dev2Vp(value: number){
    let screenWidthDP = PixelUtil.px2dp(display.getDefaultDisplaySync().width)
    let scalePx = screenWidthDP / QTPixelUtil.DEV_WIDTH
    // console.log(QUICKTVUI_TAG,`dp2px getDensityScale :${PixelUtil.getDensityScale()},getDensity:${PixelUtil.getDensity()},scalePx:${scalePx}`)
    return (value * scalePx) / PixelUtil.getDensityScale();
  }

  public static devRect2Vp(rect : HRRect){
    return new HRRect(QTPixelUtil.dev2Vp(rect.x),QTPixelUtil.dev2Vp(rect.y),QTPixelUtil.dev2Vp(rect.width),QTPixelUtil.dev2Vp(rect.height))
  }

  public static setScaledRenderViewFrame(view : HippyRenderBaseView | null, rect : HRRect | null, padding : HRPadding | null){
    if(view && rect){
      view.setRenderViewFrame(QTPixelUtil.devRect2Vp(rect),padding)
    }
  }
}
