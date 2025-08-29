import { IllegalStateException } from '@ohos/zxing';
import {HippyRenderBaseView,HippyMap,HippyAny,NativeRenderContext,HRRect} from 'hippy'
import { QUICKTVUI_TAG } from '../../Constant';
import { HRValueUtils } from '../../HRValueUtils';
import {createRenderViewFromCreator} from '../../polifill/QTViewManager'
import { NodeUtils } from '../../utils/NodeUtils';
import { TemplateCodeParser } from './TemplateCodeParser'
import { QTBaseComponentView } from '../QTBaseComponentView';
import { StyleAttach } from './StyleAttach';

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
  layout: number[] = [-1,-1,-1,-1];
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
  renderView.viewType = template.viewType
  renderView.tag = childIndex
  console.log(QUICKTVUI_TAG,`applyInit viewType:${template.viewType},size:{${template.cssWidth},${template.cssHeight}}`)
  if(renderView instanceof QTBaseComponentView){
    renderView.isVirtual = true;
    renderView.templateView = template;
    renderView.onCreateByTemplate(template)
  }
  const attach  = new StyleAttach();
  renderView.attachedInfo = attach;

  // CommonUtils.printObject(templateProps,'applyBasicStyle')
  applyBasicStyle(renderView,templateProps)
  return renderView
}


function applyBasicStyle(rendView:HippyRenderBaseView | null,styleMap: HippyMap){
  if(rendView){
    styleMap.forEach((value,key)=>{
      if(!TemplateCodeParser.parsePendingProp(value)){//不处理模板code的情况
        switch (key){
          case 'sid':
          case 'name':
            console.log(QUICKTVUI_TAG,`applyBasicStyle key:${key},value:${value},viewType:${rendView.viewType}`)
            rendView.setProp(key,value)
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
          if(updateLayoutStyle(key,dataFromValue,patch)){

          }else{
            toUpdate.set(key,dataFromValue)
          }
        }else{
          //nothing here
          // console.log(QUICKTVUI_TAG,`--gatherToUpdateMap discard key:${key},data:${CommonUtils.hippyAny2String(value)}`)
          // toUpdate.set(key,value)
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
      p.layout[2] = HRValueUtils.getNumber(value);
      return true;
    case 'height':
      p.layout[3] = HRValueUtils.getNumber(value);
      return true;
    case 'translation':
      let ts = HRValueUtils.getMap(value)
      if(ts){
        p.layout[0] = ts[0]
        p.layout[1] = ts[1]
      }
      return true;
    case 'style':
    case 'flexStyle':
      let style = HRValueUtils.getMap(value)
      if(style){
        style.forEach((value,key)=>{
          updateLayoutStyle(key,value,p)
        })
      }
      return true;
    case 'layout':
      let array = value as number[]
      if(array){
        for(let i = 0; i < 4; i ++){
          p.layout[i] = array[i]
        }
      }else{
        console.warn(QUICKTVUI_TAG,`setLayout error array:${array},value:${value},viewType:${p.renderView.viewType}`)
      }

      return true;
    case 'size':
      let size = value as number[]
      if(size){
        p.layout[2] = size[0]
        p.layout[3] = size[1]
      }else{
        console.warn(QUICKTVUI_TAG,`setSize error array:${size},value:${value},viewType:${p.renderView.viewType}`)
      }
      return true;
  }
  return false;
}
