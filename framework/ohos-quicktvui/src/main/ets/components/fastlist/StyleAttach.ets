import { QTAttach } from '../QTAttach';
import {HippyMap} from 'hippy'
import {QTNativeLayout} from 'libquicktvui.so'
export class StyleAttach extends QTAttach{
  private styleNode : QTNativeLayout | null = null;

  style() : StyleAttach{
    if(!this.styleNode){
      this.styleNode = new QTNativeLayout();
    }
    return this;
  }
  setStyles(style : HippyMap){
    this.styleNode.SetLayoutStyles(style,null)
  }



}
