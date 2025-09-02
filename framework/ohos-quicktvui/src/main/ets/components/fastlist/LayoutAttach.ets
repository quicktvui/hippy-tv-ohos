import { QTAttach } from '../QTAttach';
import {HippyMap,HippyRenderBaseView,HippyAny} from 'hippy'
import {QTNativeLayout} from 'libquicktvui.so'
import { QUICKTVUI_TAG } from '../../Constant';
import { CommonUtils } from '../../utils/CommonUtils';

export class LayoutAttach extends QTAttach{
  private styleNode : QTNativeLayout | null = null;

  private style() : QTNativeLayout{
    if(!this.styleNode){
      this.styleNode = new QTNativeLayout();
    }
    return this.styleNode as QTNativeLayout;
  }
  setStyles(style : Map<string, HippyAny> | null){
      this.style().SetLayoutStyles(style,null)
    console.debug(QUICKTVUI_TAG,`LayoutAttach setStyle:${CommonUtils.hippyMap2String(style)}`)
  }

  setWidth(value : number){
    this.style().SetWidth(value)
    console.debug(QUICKTVUI_TAG,`LayoutAttach setWidth:${value}`)
  }
  setHeight(value : number){
    this.style().SetHeight(value)
    console.debug(QUICKTVUI_TAG,`LayoutAttach setHeight:${value}`)
  }

  // setPosition(number e){
  //   this.style().SetPosition()
  // }

  calculateLayout(parentWidth: number,parentHeight: number){
    this.style().CalculateLayout(parentWidth,parentHeight)
  }

  insertChild(attach:LayoutAttach,index: number){
    this.style().InsertChild(attach.style(),index)
  }

  removeChild(attach:LayoutAttach){
    this.style().RemoveChild(attach.style())
  }

  getWidth() : number{
    return this.style().GetWidth();
  }

  getHeight(): number{
    return this.style().GetHeight();
  }

  getLeft() : number{
    return this.style().GetLeft();
  }
  getTop() : number{
    return this.style().GetTop();
  }
  getRight() : number{
    return this.style().GetRight();
  }
  getBottom() : number{
    return this.style().GetBottom();
  }
  setPosition(x: number,y : number){
    this.style().SetPosition(0,x)
    this.style().SetPosition(1,y)
  }

  public static obtainLayoutAttach(renderView:HippyRenderBaseView) : LayoutAttach{
    if(renderView.attachedInfo instanceof LayoutAttach){
      return renderView.attachedInfo as LayoutAttach
    }
    renderView.attachedInfo = new LayoutAttach();
    return renderView.attachedInfo as LayoutAttach
  }

}
