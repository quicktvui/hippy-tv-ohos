import { IllegalStateException } from '@ohos/zxing';
import {HippyRenderBaseView,HippyMap,HippyAny,NativeRenderContext,HRRect} from 'hippy'
import { QUICKTVUI_TAG } from '../../Constant';
import { HRValueUtils } from '../../HRValueUtils';
import {createRenderViewFromCreator} from '../../polifill/QTViewManager'
import { NodeUtils } from '../../utils/NodeUtils';
import { TemplateCodeParser } from './TemplateCodeParser'
import { QTBaseComponentView } from '../QTBaseComponentView';
import { LayoutAttach } from './LayoutAttach';
import { QTPixelUtil } from '../../utils/QTPixelUtil';

export class BuildResult{
  renderView : HippyRenderBaseView | null = null;
  updates : Array<PathUpdate> | null = null;
}

// class Props{
//   pendingProps : Map<string, HippyAny> | null = null;
//   basicProps : Map<string, HippyAny> | null = null;
// }

export class PathUpdate{
  renderView : HippyRenderBaseView;
  props : HippyMap;
  // layout: number[] = [-1,-1,-1,-1];
  constructor(renderView: HippyRenderBaseView, props: HippyMap) {
    this.renderView = renderView;
    this.props = props;
  }
}



export function buildRenderView(template:HippyRenderBaseView | null, templateProps:HippyMap,itemData : HippyMap,index:number) : PathUpdate | null{
  if(!template){
    return null;
  }
  let rv = createRenderViewFromCreator(template.ctx,template.viewType)
  if(!rv){
    return null;
  }
  applyInit(rv,template,templateProps,index)
  let style = new Map<String,HippyAny>()
  // toUpdate.forEach((value,key)=>{
  //   console.log(QUICKTVUI_TAG,`gatherToUpdateMap viewType:${rv?.viewType} key:${key},value:${CommonUtils.hippyAny2String(value)}`)
  // })
  // toUpdate?.forEach((value,key)=>{
  //   rv?.setProp(key,value)
  // })
  return gatherToUpdateMap(rv,templateProps,itemData,style)
}


function applyInit(renderView : HippyRenderBaseView,template: HippyRenderBaseView,templateProps:HippyMap,childIndex:number) : HippyRenderBaseView{
  const attach  = new LayoutAttach();
  renderView.attachedInfo = attach;
  renderView.viewType = template.viewType
  renderView.tag = childIndex
  applyBasicStyle(renderView,templateProps)
  console.log(QUICKTVUI_TAG,`applyInit viewType:${template.viewType},size:{${template.cssWidth},${template.cssHeight}} name:${LayoutAttach.obtainLayoutAttach(renderView).name}`)
  if(renderView instanceof QTBaseComponentView){
    renderView.isVirtual = true;
    renderView.templateView = template;
    renderView.onCreateByTemplate(template)
  }

  // CommonUtils.printObject(templateProps,'applyBasicStyle')
  return renderView
}


function applyBasicStyle(rendView:HippyRenderBaseView | null,styleMap: HippyMap){
  if(rendView){
    styleMap.forEach((value,key)=>{
      if(!TemplateCodeParser.parsePendingProp(value)){//不处理模板code的情况
        switch (key){
          case 'sid':
            LayoutAttach.obtainLayoutAttach(rendView).sid = HRValueUtils.getString(value);
            return;
          case 'name':
            LayoutAttach.obtainLayoutAttach(rendView).name = HRValueUtils.getString(value);
            //rendView.setProp(key,value)
            return ;
        }
      }
    })
  }
}



export function buildRenderViewTraverse(ctx:NativeRenderContext | null, template : HippyRenderBaseView | null, templateProps:HippyMap,itemData : HippyMap,parent: HippyRenderBaseView | null,index:number,
    updates:Array<PathUpdate>
): HippyRenderBaseView | null{
  if(!ctx){
    return null;
  }
  let patch = buildRenderView(template,templateProps,itemData,index)
  if(!patch){
    return null;
  }
  updates.push(patch)
  if(parent){
    parent.addSubRenderView(patch.renderView,index)
    //添加layout node
    LayoutAttach.obtainLayoutAttach(parent).insertChild(LayoutAttach.obtainLayoutAttach(patch.renderView),index)
    //parent.attachedInfo
  }
  template?.children?.map((child,index)=>{
    let childNode = NodeUtils.getNodeById(ctx,child.tag)
    if(!childNode){
      throw new IllegalStateException(`child node is null tag :${child.tag},viewType:${child.viewType}`)
    }

    buildRenderViewTraverse(ctx,child,childNode!!.props!!,itemData,patch!!.renderView,index,updates)
  })
  return patch.renderView
}

export function gatherToUpdateMap(rendView:HippyRenderBaseView ,templateProps:HippyMap,itemData : HippyMap,style : Map<String,HippyAny>) : PathUpdate{
  let toUpdate = new Map<string, HippyAny>()
  let patch = new PathUpdate(rendView,toUpdate)
  templateProps.forEach((value,key)=>{
    if(!(TemplateCodeParser.PENDING_PROP_CREATE_IF === key)){
      if(TemplateCodeParser.isEquationProp(value)){
        let b = TemplateCodeParser.parseBooleanFromPendingProp(key,itemData,value)
        toUpdate.set(key,b)
      }else{
        let pendingProp = TemplateCodeParser.parsePlaceholderProp(key,templateProps)
        if(pendingProp){
          let dataFromValue = TemplateCodeParser.getValueFromCode(itemData,pendingProp)
          // console.info(QUICKTVUI_TAG,`++put pendingProp key:${key},dataFromValue:${dataFromValue},pendingProp:${pendingProp} ,value:${value},data:${CommonUtils.hippyAny2String(dataFromValue)}`)
          //从${xx}取出dataFromValue数据
          if(updateLayoutStyle(key,dataFromValue,patch)){

          }else{
            toUpdate.set(key,dataFromValue)
          }
        }else{
          // console.log(QUICKTVUI_TAG,`--gatherToUpdateMap discard key:${key},data:${CommonUtils.hippyAny2String(value)}`)
          // toUpdate.set(key,value)
          //原数据没有${xx}，直接按value处理
          if(!updateLayoutStyle(key,value,patch)){
            toUpdate.set(key,value)
          }
        }
      }
    }
  })
  return patch
}

function updateLayoutStyle(key:String,value:HippyAny,p:PathUpdate) : boolean{
  switch (key){
    case 'width':
      // (p.renderView.attachedInfo as StyleAttach).style().setStyles()
      // p.layout[2] = HRValueUtils.getNumber(value);
      LayoutAttach.obtainLayoutAttach(p.renderView).setWidth(QTPixelUtil.getDimensionValue(value))
      return true;
    case 'height':
      //p.layout[3] = HRValueUtils.getNumber(value);
      LayoutAttach.obtainLayoutAttach(p.renderView).setHeight(QTPixelUtil.getDimensionValue(value))
      return true;
    case 'translation':
      let ts = value as number[]
      // if(ts){
      //   p.layout[0] = ts[0]
      //   p.layout[1] = ts[1]
      // }
      LayoutAttach.obtainLayoutAttach(p.renderView).setPosition(QTPixelUtil.vp2Vp(ts[0]),QTPixelUtil.vp2Vp(ts[1]))
      return true;
    case 'style':
    case 'flexStyle':
      console.log(QUICKTVUI_TAG,`updateLayoutStyle key:${key},value:${value},viewType:${p.renderView.viewType}`)
      let style = HRValueUtils.getMap(value)
      // if(style){
      //   style.forEach((value,key)=>{
      //     updateLayoutStyle(key,value,p)
      //   })
      // }
      if(style){
        LayoutAttach.obtainLayoutAttach(p.renderView).setStyles(style)
      }
      return true;
    case 'layout':
      let array = value as number[]
      // if(array){
      //   for(let i = 0; i < 4; i ++){
      //     p.layout[i] = array[i]
      //   }
      // }else{
      //   console.warn(QUICKTVUI_TAG,`setLayout error array:${array},value:${value},viewType:${p.renderView.viewType}`)
      // }
      LayoutAttach.obtainLayoutAttach(p.renderView).setPosition(QTPixelUtil.vp2Vp(array[0]),QTPixelUtil.vp2Vp(array[1]))
      LayoutAttach.obtainLayoutAttach(p.renderView).setWidth(QTPixelUtil.vp2Vp(array[2]))
      LayoutAttach.obtainLayoutAttach(p.renderView).setHeight(QTPixelUtil.vp2Vp(array[3]))
      return true;
    case 'size':
      let size = value as number[]
      // if(size){
      //   p.layout[2] = size[0]
      //   p.layout[3] = size[1]
      // }else{
      //   console.warn(QUICKTVUI_TAG,`setSize error array:${size},value:${value},viewType:${p.renderView.viewType}`)
      // }
      LayoutAttach.obtainLayoutAttach(p.renderView).setWidth(QTPixelUtil.vp2Vp(size[0]))
      LayoutAttach.obtainLayoutAttach(p.renderView).setHeight(QTPixelUtil.vp2Vp(size[1]))
      return true;
  }
  return false;
}
