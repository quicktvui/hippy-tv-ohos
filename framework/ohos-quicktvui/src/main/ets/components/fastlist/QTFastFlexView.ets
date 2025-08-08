import {
  HIPPY_COMPONENT_KEY_PREFIX,
  HippyObservedArray,
  NativeRenderContext,
  HippyAny,
  HippyMap,
  HippyArray,
  HippyRenderCallback,
  HippyEndBatchCallback,
  HippyRenderBaseView
} from 'hippy'
import { QUICKTVUI_TAG } from '../../Constant';
import { HRValueUtils } from '../../HRValueUtils';
import { CommonUtils } from '../../utils/CommonUtils';
import { NodeUtils } from '../../utils/NodeUtils';
import QTRenderBaseView from '../QTRenderBaseView';
import { FastListDataSource } from './FastListDataSource';
import { ItemView, renderItem } from './ItemView';


@Observed
export class QTFastFlexView extends QTRenderBaseView {
  public dataList: HippyObservedArray<ItemView> = new HippyObservedArray()
  dataSource: FastListDataSource | null = null;

  constructor(ctx: NativeRenderContext) {
    super(ctx)
    this.dataSource = new FastListDataSource(ctx,this.dataList)
  }


  onChildInserted(childTag: number, childViewName: string, childIndex: number): void {
    console.error(QUICKTVUI_TAG,`QTFastFlexView onChildInserted tag :${childTag},childViewName:${childViewName},childIndex:${childIndex}`)
  }

  aboutToUpdate(): void {
    let children = this.templateView?.children
    console.error(QUICKTVUI_TAG,`QTFastFlexView aboutToUpdate!! children size:${children?.length}`)
    NodeUtils.printViewTreePretty(this,'',false)
    children?.map((c,index)=>{
      if(c.tag != -1){
        console.log(QUICKTVUI_TAG,`QTFastFlexView template: viewType：`+c.viewType+",node:"+NodeUtils.getNodeById(this.ctx,c.tag))
        this.dataSource?.registerTemplate(c,index,this.isVirtual)
      }else{
        console.error(QUICKTVUI_TAG,`QTFastFlexView registerTemplate error child id is -1`)
      }

    })
  }

  onDataChanged(data : HippyArray | null){
    if(data && data.length > 0){
      for(let  i = 0; i < data.length; i++){
        let item : ItemView = new ItemView(i,data[i] as HippyMap);
        this.dataSource?.buildItem(item)
        this.dataList.push(item)
        // console.log(QUICKTVUI_TAG,`FastFlex put item index:${i},data:`)
        CommonUtils.printMapPretty(item.raw as HippyMap,'FastFlex:',false)
      }
      // this.dataList.push(...
      //   data?.map((item,index)=>{
      //     return new ItemView(index,item as HippyMap)
      //   })
      // )
    }else{
      this.dataList = []
    }
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    switch (propKey) {
      case "cachePool":
        console.log(QUICKTVUI_TAG,`FastFlex:setCachePool :${propValue}`)
        return true;
      case "firstFocusChild":
        console.log(QUICKTVUI_TAG,`FastFlex:firstFocusChild :${propValue}`)
        return true;
      case "list":
        if(propValue instanceof Array){
          console.log(QUICKTVUI_TAG,`FastFlex:setListData:${HRValueUtils.getArray(propValue)}`)
          this.onDataChanged(HRValueUtils.getArray(propValue))
        }else{
          console.error(QUICKTVUI_TAG,`FastFlex:setListData error list is not array propValue:${propValue}`)
        }
        return true;
      case "sharedItemStore":
        console.log(QUICKTVUI_TAG,`FastFlex:sharedItemStore :${propValue}`)
        return true;

    }
    //不支持或者不处理的key
    switch (propKey) {
      case "display":
      case "setData":
      case "suspendUpdateTaskOnPause":
      case "listenBoundEvent":
      case "verticalScrollBarEnabled":
      case "horizontalScrollBarEnabled":
      case "checkScrollOffsetOnStateChanged":
      case "scrollEventThrottle":
      case "enableScrollOffsetEvent":
      case "listenFocusSearchOnFail":
      case "useAdvancedFocusSearch":
      case "negativeKeyTime":
      case "postContentDelay":
      case "placeholderPostDelay":
      case "initFocusPositionAfterLayout":
      case "enableGridLoad":
      case "enableKeepFocus":
      case "disableScroll":
      case "scrollFactor":
      case "setLoadDelayTime":
      case "autofocusPositionInfiniteMode":
      case "autoscrollInfiniteMode":
      case "autoSelectPosition":
      case "useLayoutAnimation":
      case "useDiff":
      case "keyName":
        console.error(QUICKTVUI_TAG,`QTFastFlexView : 未实现propKey : ${propKey}`)
        return true;
      default:
        console.warn(QUICKTVUI_TAG,`QTFastFlexView : 未知的未实现propKey : ${propKey}`)
        break;
    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {

    switch (method) {
      case 'scrollToPositionWithOffsetInfiniteMode':
      case 'setGroupChildSelectByItemPosition':
      case 'refreshListData':
      case 'requestItemLayout':
      case 'destroy':
      case 'recycle':
      case 'prepareForRecycle':
      case 'setDisplay':
      case 'changeDisplayState':
      case 'notifySaveInstance':
      case 'notifyRestoreInstance':
      case 'clearAllPostTask':
      case 'clearPostTaskByCate':
      case 'pausePostTask':
      case 'resumePostTask':
      case 'requestLayoutManual':
      case 'setBackgroundColor':
      case 'setCustomStateEnableOnFocus':
      case 'setItemCustomState':
      case 'scheduleLayoutAnimation':
        console.error(QUICKTVUI_TAG,`QTFastFlexView : 未实现的function : ${method}`)
        return;
    }

    switch (method) {
      case 'updateItem':

        break;
    }
  }
}

@Component
export struct QTFastFlex {
  @ObjectLink renderView: QTFastFlexView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>
  private endBatchCallback: HippyEndBatchCallback | null = null

  private handleOnChildrenUpdated() {
    console.log(QUICKTVUI_TAG,`QTFastFlexView: handleOnChildrenUpdated children:${this.children.length}`)

  }

  build(): void {
    Row() {
      ForEach(this.renderView.dataList,(item : ItemView)=>{
        renderItem(item)
      },(item : ItemView,index)=>{
        return item.id as string
      })
      // ContentSlot(this.renderView.childSlot)
    }
    .backgroundColor(Color.Blue)
    .applyRenderViewBaseAttr(this.renderView)
  }



  aboutToAppear(): void {
    console.error(QUICKTVUI_TAG,`QTFastFlex aboutToAppear`)
    // this.endBatchCallback = () =>{
    // }
    // this.renderView.ctx.getNativeRender().addEndBatchCallback(this.renderView.ctx.getRootId(),this.endBatchCallback)
  }

  getSid(){
    return ''
  }

  aboutToDisappear(): void {
    if(this.endBatchCallback){
      this.renderView.ctx.getNativeRender().removeEndBatchCallback(this.renderView.ctx.getRootId(),this.endBatchCallback)
    }
  }

}

@Extend(Row)
function applyRenderViewBaseAttr($$: QTFastFlexView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
  .size({width:$$.cssWidth, height: $$.cssHeight})
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as QTFastFlexView).cssVisibility) // must add as, otherwise the compiler has error
  .zIndex($$.cssZIndex)
  .accessibilityText($$.cssAccessibilityLabel)
  .focusable($$.cssFocusable)
  .border($$.cssBorder)
  .shadow($$.cssShadow)
  .linearGradient($$.cssLinearGradient)
  .backgroundImage($$.cssBackgroundImage)
  .backgroundImageSize($$.cssBackgroundImageSize)
  .backgroundImagePosition($$.cssBackgroundImagePosition)
  .transform($$.cssMatrix)
  .rotate($$.cssRotate)
  .scale($$.cssScale)
  .translate($$.cssTranslate)
  .hitTestBehavior($$.hitTestBehavior)
  .onClick($$.eventClick)
}
