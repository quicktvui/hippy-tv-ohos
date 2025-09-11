import {HippyMap,HippyRenderBaseView,HippyAny} from 'hippy'
import { TAG_CLICK } from '../../Constant'
import { ExtendUtil } from '../../utils/ExtendUtil'
import { QTBaseComponentView } from '../QTBaseComponentView'
import { ItemView } from './ItemView'
import { LayoutAttach } from './LayoutAttach'
import { QTFastFlexView } from './QTFastFlexView'
import { QTFastListView } from './QTFastListView'
import { QTPendingListView, QTView } from '../../QTTypes'
import { CommonUtils } from '../../utils/CommonUtils'
import { QTFastItemView } from './QTFastItemView'

export class FastListUtils{
  static handleItemClick(clickView :QTView){
    console.info(TAG_CLICK,`onClick rootID:${LayoutAttach.obtainLayoutAttach(clickView).virtualExtra.rootListId}`)
    let rootListId = LayoutAttach.obtainLayoutAttach(clickView).virtualExtra.rootListId
    if(rootListId != -1){
      let itemView :ItemView | null | undefined = FastListUtils.findItemView(clickView)?.itemView
      if(!itemView){
        console.error(TAG_CLICK,"handleItemClick error findItemView null ")
        return;
      }
      let parentList = FastListUtils.findListParent(itemView.renderView)
      let pendingList : QTPendingListView | null = null;
      let itemPosition  = -1
      // if(parentList){
      //   pendingList = parentList as QTPendingListView
      //   itemPosition = pendingList.itemIndexOfDataList(itemView)
      // }else{
      //   console.error(TAG_CLICK,`handleItemClick error find pendingList null ,itemView parent:${itemView.renderView?.parentView}`)
      // }
      let itemRaw = itemView.raw
      let name = LayoutAttach.obtainLayoutAttach(clickView).name
      let sid = LayoutAttach.obtainLayoutAttach(clickView).sid
      let index = clickView.parentView?.children.indexOf(clickView)
      let map = new Map<string,HippyAny>()
      let parentPosition = -1;
      if(pendingList){
        parentPosition = FastListUtils.findParentItemPosition(pendingList)
      }
      //basic
      map.set('index',index)
      map.set('sid',sid)
      map.set('position',itemPosition)
      map.set('name',name)
      if(itemRaw){
        map.set('item',itemRaw)
      }
      map.set('parentPosition',parentPosition)
      console.log(TAG_CLICK,`sendd onItemClick data:${CommonUtils.hippyMap2String(map)} `)
      ExtendUtil.sendUIEvent(clickView.ctx,rootListId,'onItemClick',map)
    }else{
      console.error(TAG_CLICK,`handleItemClick error rootListId is -1 clickView:${ExtendUtil.debugView(clickView)}`)
    }
  }

  static findItemView(view:QTView | null) : QTFastItemView | null{
    if(view == null){
      return null;
    }
    if(view instanceof QTFastItemView){
      return view;
    }
    return FastListUtils.findItemView(view.parentView)
  }

  static findListParent(view: QTView  |  null) : QTView | null{
    if(view == null){
      return null;
    }
    if(view instanceof QTFastListView){
      return view;
    }
    if(view instanceof QTFastFlexView){
      return view;
    }
    return FastListUtils.findListParent(view.parentView)
  }

  static findItemPosition(view:QTView | null) : number{
    let fi :QTFastItemView | null = FastListUtils.findItemView(view)
    if(!fi){
      return -1;
    }
    let parentView = FastListUtils.findListParent(view)
    if(parentView instanceof QTFastListView){
      return parentView.itemIndexOfDataList(fi)
    }
    if(parentView instanceof QTFastFlexView){
      return parentView.itemIndexOfDataList(fi)
    }
    return -1;
  }

  static findParentItemPosition(view:QTView | null): number{
    //向一寻找一层嵌套的列表
    let directParentList = FastListUtils.findListParent(view)
    if(directParentList instanceof QTBaseComponentView){
      if(!directParentList.isVirtual){
          //如果直接parentList，不是一个virtual的View,直接返回-1,因为它不是一个嵌套的列表
      }
    }
    if(directParentList){
      return FastListUtils.findItemPosition(directParentList)
    }else{
      return -1;
    }
  }

}
