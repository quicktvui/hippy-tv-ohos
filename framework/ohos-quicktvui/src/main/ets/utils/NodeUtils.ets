import {HippyRenderBaseView,HippyObservedArray,NativeRenderContext,NativeRender,HippyMap} from 'hippy'
export function getNodeById(ctx : NativeRenderContext,tag : number){
  return ctx.getNativeRender().getRenderManager().getVirtualNodeManager(ctx.getRootId())?.getVirtualNode(tag)
}

export function getRenderView(ctx : NativeRenderContext,tag : number){
  return ctx.getNativeRender().getRenderManager().getViewManager(ctx.getRootId())?.getRenderView(tag)
}




