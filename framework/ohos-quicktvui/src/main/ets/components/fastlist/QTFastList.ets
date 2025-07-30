import { QTFastListView } from "./QTFastListView"
import {HippyObservedArray,HRDiv,HIPPY_COMPONENT_KEY_PREFIX,HippyRenderBaseView,buildHippyRenderView,HippyMap,HippyEndBatchCallback} from 'hippy'
import { QUICKTVUI_TAG } from "../../Constant";
import { FastListDataSource } from "./FastListDataSource";
import { ItemView, renderItem } from "./ItemView";
import { getNodeById } from "../../utils/NodeUtils";
import hilog from "@ohos.hilog";

@Component
export struct  QTFastList {
  @ObjectLink renderView: QTFastListView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  test : boolean = false
  dataSource: FastListDataSource | null = null;
  @State bgColor : Color = Color.Yellow
  private endBatchCallback: HippyEndBatchCallback | null = null


  build(): void {
    if(this.test){
      Stack() {
        ForEach(this.children, (item: HippyRenderBaseView) => {
          buildHippyRenderView(item, null)
        }, (item: HippyRenderBaseView) => item.tag + '')
        // ContentSlot(this.renderView.childSlot)
      }
      .applyRenderViewBaseAttr(this.renderView)
      .backgroundColor(this.bgColor)
    }else{
      Stack() {
        List(){
          LazyForEach(this.dataSource,(item : ItemView,index : number)=>{
            renderItem(item)
          })
        }
        .divider({
          strokeWidth: 2,  // 分隔线宽度
          color: 'white',  // 分隔线颜色
        })
        .width('100%')
        .height('100%')
        // ContentSlot(this.renderView.childSlot)
      }
      .applyRenderViewBaseAttr(this.renderView)
      .backgroundColor(this.bgColor)
    }

  }

  public notifyReload(){
    this.dataSource?.notifyReload()
  }

  private handleOnChildrenUpdated() {
    this.bgColor = Color.Green
    console.log(QUICKTVUI_TAG,`QTFastList: handleOnChildrenUpdated children:${this.children.length}`)
    this.children.map((c,index)=>{
      console.log(QUICKTVUI_TAG,`template: viewType：`+c.viewType+",node:"+getNodeById(this.renderView.ctx,c.tag))
      this.dataSource?.registerTemplate(c,index)
    })

  }


  aboutToAppear(): void {
    console.log(QUICKTVUI_TAG,`FastList aboutToAppear childrenCount:${this.children.length}`)
    this.renderView.uiCtx = this.getUIContext()
    this.dataSource = new FastListDataSource(this.renderView.ctx,this.renderView.dataList)
    this.renderView.ui  = this

    this.handleOnChildrenUpdated()
    this.endBatchCallback = () =>{
      this.handleOnChildrenUpdated()
    }
    this.renderView.ctx.getNativeRender().addEndBatchCallback(this.renderView.ctx.getRootId(),this.endBatchCallback)
    if (this.renderView.eventAttachedToWindow) {
      this.renderView.eventAttachedToWindow()
    }
  }

  aboutToDisappear() {
    if (this.renderView.eventDetachedFromWindow) {
      this.renderView.eventDetachedFromWindow()
    }
    this.renderView.clearListener()
    if(this.endBatchCallback){
      this.renderView.ctx.getNativeRender().removeEndBatchCallback(this.renderView.ctx.getRootId(),this.endBatchCallback)
    }
  }

}



@Extend(Stack)
function applyRenderViewBaseAttr($$: QTFastListView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
  .size({width:$$.cssWidth, height: $$.cssHeight})
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as QTFastListView).cssVisibility) // must add as, otherwise the compiler has error
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
