import {NativeRenderContext} from 'hippy'
export class NodeUtils{
  static getNodeById(ctx : NativeRenderContext,tag : number){
    return ctx.getNativeRender().getRenderManager().getVirtualNodeManager(ctx.getRootId())?.getVirtualNode(tag)
  }

  static getRenderView(ctx : NativeRenderContext,tag : number){
    return ctx.getNativeRender().getRenderManager().getViewManager(ctx.getRootId())?.getRenderView(tag)
  }
}







