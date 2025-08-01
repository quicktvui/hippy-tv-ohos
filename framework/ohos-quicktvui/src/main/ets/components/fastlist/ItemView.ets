import {HippyRenderBaseView,HippyMap,HippyAny,buildHippyRenderView,HRDivView} from 'hippy'
import {buildRenderViewTraverse} from '../TemplateViewManager'
import { QTPlaceholderView } from './QTPlaceholderView';

export class ItemTemplate  {
  templateView: HippyRenderBaseView;
  viewType:number;
  props:HippyMap;

  constructor(templateView: HippyRenderBaseView, viewType: number, props: HippyMap) {
    this.templateView = templateView;
    this.viewType = viewType;
    this.props = props;
  }
}

@Observed
export class ItemView{
  // template: HippyRenderBaseView | undefined = undefined;
  template:ItemTemplate | undefined = undefined
  position: number;
  raw:HippyMap | null;
  renderView:HippyRenderBaseView | null = null;
  constructor(position: number, raw : HippyMap | null) {
    this.position = position
    this.raw = raw
  }
}



// @Builder
// export function createView4Template(template : ItemTemplate) : HippyRenderBaseView{
//   return buildRenderViewByTemplate(template,)
// }
//
// @Builder
// export function renderView(template : ItemTemplate,data:HippyMap){
//   Stack(){
//     buildHippyRenderView()
//   }
// }

// @Component
// export struct Item{
//   @ObjectLink itemData : ItemView;
//
//   constructor(itemData : ItemView) {
//     super()
//     this.itemData = itemData;
//   }
//
//   build() {
//     Text(`位置:${this.itemData.position}`)
//     .width('100%')
//     .height('100%')
//   }
//
// }



@Builder
export function  renderItem(item : ItemView){
  if(item.template && item.raw){
    buildHippyRenderView(
      buildRenderViewTraverse(item.template.templateView.ctx,
        item.template.templateView,
        item.template.props,
        item.raw,
        null,
        0) ?? new QTPlaceholderView(item.template.templateView.ctx),null
    )
  }else{
    Text(`未实现:${item.position},viewName:${item.template?.viewType}`)
      .width('100%')
      .height(100)
  }

}

export function getItemType(map : HippyMap | null) : number | null{
  return getAsNumber(map,'type')
}

// 从 Map 中安全提取并转换值的函数
function getAsNumber(map: HippyMap | null, key: string): number | null {
  if (map === undefined || map === null) {
    return null;
  }
  const value = map.get(key);

  if (value === undefined || value === null) {
    return null;
  }

  // 如果是 number 类型直接返回
  if (typeof value === 'number') {
    return value;
  }

  // 如果是 string 类型尝试转换为 number
  if (typeof value === 'string') {
    const num = Number(value);
    return isNaN(num) ? null : num;
  }
  // 其他类型返回 null
  return null;
}
