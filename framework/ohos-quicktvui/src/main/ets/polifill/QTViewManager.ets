import {HippyRenderBaseView,NativeRenderContext,hippyRenderViewCreatorRegisterMap,HRRenderViewCreator,HippyMap} from 'hippy'
import { QTDivView } from '../components/QTDivView';

let myHippyRenderViewCreatorRegisterMap :Map<string, HRRenderViewCreator> | null
let myCustomRenderViewCreatorRegisterMap :Map<string, HRRenderViewCreator> | null

export function createRenderViewFromCreator(ctx:NativeRenderContext | null, viewName: string): HippyRenderBaseView | null {
  if(!ctx){
    return null
  }
  if(!myHippyRenderViewCreatorRegisterMap){
    myHippyRenderViewCreatorRegisterMap = hippyRenderViewCreatorRegisterMap();
    //这里将div替换成自己的div
    myHippyRenderViewCreatorRegisterMap.set("View", (ctx): HippyRenderBaseView => new QTDivView(ctx))
  }

  if(!myCustomRenderViewCreatorRegisterMap){
    myCustomRenderViewCreatorRegisterMap = ctx.getCustomRenderViewCreatorMap();
  }
  let creator = myHippyRenderViewCreatorRegisterMap.get(viewName) ?? myCustomRenderViewCreatorRegisterMap?.get(viewName);
  if(creator){
    return creator(ctx)
  }
  return null
}


