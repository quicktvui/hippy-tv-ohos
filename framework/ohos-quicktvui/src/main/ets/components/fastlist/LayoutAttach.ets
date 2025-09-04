import { QTAttach } from '../QTAttach';
import {HippyMap,HippyRenderBaseView,HippyAny,HRRect} from 'hippy'
import {QTNativeLayout} from 'libquicktvui.so'
import { TAG_LAYOUT, TAG_QUICKTVUI } from '../../Constant';
import { CommonUtils } from '../../utils/CommonUtils';

export class LayoutAttach extends QTAttach{
  private styleNode : QTNativeLayout | null = null;
  private scale:number = 0.75
  private style() : QTNativeLayout{
    if(!this.styleNode){
      this.styleNode = new QTNativeLayout();
    }
    return this.styleNode as QTNativeLayout;
  }

  copyStyleNode(instanceId: number, rootId: number, nodeId: number,){
    this.style().CopyStyleNode(instanceId,rootId,nodeId)
  }
  setStyles(style: Map<string, HippyAny> | null) {
    // console.error(TAG_LAYOUT, `LayoutAttach setStyle:${CommonUtils.hippyMap2String(style)},name:${this.name},viewType:${this.viewType}`)
    // 将 Map 转换为普通对象的正确方式
    let styleObj: Record<string, HippyAny> = {};
    if (style) {
      style.forEach((value: HippyAny, key: string) => {
        // 使用正确的方式设置对象属性
        (styleObj as Record<string, HippyAny>)[key] = value;
      });
    }
    this.style().SetLayoutStyles(styleObj)  // 传递普通对象而不是 Map
  }

  setWidth(value : number){
    this.style().SetWidth(value )
    // console.debug(TAG_LAYOUT,`LayoutAttach setWidth:${value}`)
  }
  setHeight(value : number){
    this.style().SetHeight(value)
    // console.debug(TAG_LAYOUT,`LayoutAttach setHeight:${value}`)
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
