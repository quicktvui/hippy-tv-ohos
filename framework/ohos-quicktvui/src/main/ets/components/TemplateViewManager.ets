import {HippyRenderBaseView,HippyMap,HippyAny,NativeRenderContext} from 'hippy'
import { QUICKTVUI_TAG } from '../Constant';
import {createRenderViewFromCreator} from '../polifill/QTViewManager'
import { NodeUtils } from '../utils/NodeUtils';
import { TemplateCodeParser } from './fastlist/TemplateCodeParser'
import { QTBaseComponentView } from './QTBaseComponentView';

export class BuildResult{
  renderView : HippyRenderBaseView | null = null;
  updates : Array<PathUpdate> | null = null;
}

export class PathUpdate{
  renderView : HippyRenderBaseView;
  props : HippyMap;
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
  applyInit(rv,template,index)


  let toUpdate = gatherToUpdateMap(templateProps,itemData)
  // toUpdate.forEach((value,key)=>{
  //   console.log(QUICKTVUI_TAG,`gatherToUpdateMap viewType:${rv?.viewType} key:${key},value:${CommonUtils.hippyAny2String(value)}`)
  // })
  // toUpdate?.forEach((value,key)=>{
  //   rv?.setProp(key,value)
  // })
  return new PathUpdate(rv,toUpdate)
}


function applyInit(renderView : HippyRenderBaseView,template: HippyRenderBaseView,childIndex:number) : HippyRenderBaseView{
  renderView.viewType = template.viewType
  renderView.tag = childIndex
  console.log(QUICKTVUI_TAG,`applyInit viewType:${template.viewType},size:{${template.cssWidth},${template.cssHeight}}`)
  if(renderView instanceof QTBaseComponentView){
    renderView.isVirtual = true;
    renderView.onCreateByTemplate(template)
  }
  return renderView
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
    buildRenderViewTraverse(ctx,child,childNode!!.props!!,itemData,patch!!.renderView,index,updates)
  })
  return patch.renderView
}

export function gatherToUpdateMap(templateProps:HippyMap,itemData : HippyMap){
  let toUpdate = new Map<string, HippyAny>()
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
          toUpdate.set(key,dataFromValue)
        }else{
          //nothing here
          // console.log(QUICKTVUI_TAG,`--gatherToUpdateMap discard key:${key},data:${CommonUtils.hippyAny2String(value)}`)
          // toUpdate.set(key,value)
        }
      }
    }
  })
  return toUpdate
}

