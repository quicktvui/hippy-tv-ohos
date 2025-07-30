/*
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2022 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import {HippyRenderBaseView,HippyObservedArray,NativeRenderContext,NativeRender} from 'hippy'
import { QUICKTVUI_TAG } from '../../Constant';
import {HippyMap,HippyArray,HippyAny} from 'hippy'
import {ItemView,getItemType, ItemTemplate} from './ItemView'
import {getNodeById,getRenderView} from '../../utils/NodeUtils'
import assertNull from '@ohos/hypium/src/main/module/assert/assertNull';



// class ItemEntry{
//   position: number;
//   raw:HippyAny;
//   constructor(position: number, raw : HippyAny) {
//     this.position = position
//     this.raw = raw
//   }
// }

export class FastListDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private templates: HippyObservedArray<HippyRenderBaseView> = [];
  private dataList: HippyObservedArray<ItemView> = [];

  private ctx : NativeRenderContext;
  private templatesMap : Map<number,ItemTemplate> = new Map()

  constructor(ctx : NativeRenderContext,dataList:HippyObservedArray<ItemView>) {
    this.ctx = ctx;
    assertNull(ctx) ?? 'ctx is null'
    // this.mockData()
    this.dataList = dataList;
  }

  public setTemplates(templates : HippyObservedArray<HippyRenderBaseView>){
    this.templates = templates;
    console.info(QUICKTVUI_TAG, `setTemplates total:${templates.length}`)
  }

  public registerTemplate(child: HippyRenderBaseView,childIndex: number){
    let childTag = child.tag
    let childViewName = child.viewType
    let node = getNodeById(this.ctx,childTag)
    // let renderView = getRenderView(this.ctx,childTag)
    if(child == null || node == null){
      console.error(QUICKTVUI_TAG,`registerTemplate error renderView:${child},node:${node},viewName:${childViewName}`)
      return;
    }
    if(node?.props){
      let type = getItemType(node.props)
      if(type && child){
        console.log(QUICKTVUI_TAG,`registerTemplate type:${type},renderView:${child}`)
        let it : ItemTemplate = new ItemTemplate(child,type,node.props)
        this.templatesMap.set(type,it)
      }
    }
  }


  public getData(index: number): ItemView {
    let item = this.dataList[index]
    let type = getItemType(item.raw)
    if(type){
      let template = this.templatesMap.get(type);
      item.template = template;
    }
    return item
  }

  // public setListData(rawList : HippyArray){
  //   this.dataList = []
  //   this.notifyReload()
  // }

  // setListDataInner(data : ItemView[]){
  //   this.dataList = data;
  //   this.itemCount = this.dataList.length
  // }

  // 添加新数据
  // public addData(item: ItemView): void {
  //   this.dataList.push(item);
  //   this.notifyDataAdd(this.dataList.length - 1);
  // }

  public totalCount(): number {
    console.log(QUICKTVUI_TAG,`dataSource:totalCount:${this.dataList.length}`)
    return this.dataList.length
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyReload() {
    console.log(QUICKTVUI_TAG,'notifyReload called')
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index : number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  mockData(){
    const total = 100;
    for(let i = 0; i < total; i++){
      let map : Map<string, HippyAny> = new Map()
      map.set('type',10001)
      let item = new ItemView(i,map)
      this.dataList.push(item)
    }
    this.notifyReload()
  }
}
