import {HippyRenderBaseView,HippyMap,HippyAny,NativeRenderContext} from 'hippy'
import { QUICKTVUI_TAG } from '../Constant';
import {createRenderViewFromCreator} from '../polifill/QTViewManager'
import { HippyUtils } from '../utils/HippyUtils';
import { getNodeById } from '../utils/NodeUtils'
import { TemplateCodeParser } from './fastlist/TemplateCodeParser'


export function buildRenderViewByTemplate(template:HippyRenderBaseView | null, templateProps:HippyMap,itemData : HippyMap): HippyRenderBaseView | null{
  if(!template){
    return null;
  }
  let rv = createRenderViewFromCreator(template.ctx,template.viewType)
  let toUpdate = gatherToUpdateMap(templateProps,itemData)
  toUpdate.forEach((value,key)=>{
    console.log(QUICKTVUI_TAG,`gatherToUpdateMap key:${key},value:${value}`)
  })
  toUpdate?.forEach((value,key)=>{
    rv?.setProp(key,value)
  })
  return rv
}

export function buildRenderViewByTemplateTraverse(ctx:NativeRenderContext | null, template:HippyRenderBaseView | null, templateProps:HippyMap,itemData : HippyMap,parent: HippyRenderBaseView | null,index:number): HippyRenderBaseView | null{
  if(!ctx){
    return null;
  }
  let rv = buildRenderViewByTemplate(template,templateProps,itemData)
  if(parent){
    parent.addSubRenderView(rv!!,index)
  }
  template?.children?.map((child,index)=>{
    let childNode = getNodeById(ctx,child.tag)
    buildRenderViewByTemplateTraverse(ctx,child,childNode!!.props!!,itemData,rv!!,index)
  })
  return rv
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
          // console.info(QUICKTVUI_TAG,`++put pendingProp key:${key},dataFromValue:${dataFromValue},pendingProp:${pendingProp} ,value:${value},data:${HippyUtils.hippyMap2String(itemData)}`)
          toUpdate.set(key,dataFromValue)
        }else{
          console.log(QUICKTVUI_TAG,`--put origin key:${key},value:${value}`)
          toUpdate.set(key,value)
        }
      }
    }
  })
  return toUpdate
}

