import {
  HippyRenderBaseView,
  HippyObservedArray,
  HRDiv,
  NativeRenderContext,
  HippyAny,
  HippyRenderCallback
} from 'hippy'


@Observed
export class QTFastListView extends HippyRenderBaseView {
  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }


  setProp(propKey: string, propValue: HippyAny): boolean {
    switch (propKey) {
      case "scrollOffset":

        return true;
      case "initPosition":

        return true;

      case "enableItemAnimator":
        return true;
      case "disableScrollOnFirstScreen":

        return true;
      case "taskPaused":

        return true;
      case "resetOnDetach":

        return true;

      case "scrollEnabled":

        return true;
      case "firstFocusChild":

        return true;

      case "enableFirstFocusAtStart":

        return true;

      case "enablePlaceholder":

        return true;
      case "refocusType":

        return true;
      case "onScrollEnable":

        return true;
      case "scrollYLesserReferenceValue":

        return true;
      case "scrollYGreaterReferenceValue":

        return true;
      case "layoutTargetPosition":

        return true;

      case "makeChildVisibleType":

        return true;

      case "makeChildVisibleClampBackward":

        return true;
      case "makeChildVisibleClampForward":

        return true;
      case "scrollThresholdHorizontal":

        return true;
      case "scrollThresholdVertical":

        return true;
      case "cachePool":

        return true;
      case "cachePoolName":

        return true;
      case "focusMemory":

        return true;
      case "pauseTaskOnHide":

        return true;
      case "setSelectChildPosition":

        return true;
      case "selectChildPosition":

        return true;
      case "shakePreCheckNumber":

        return true;
      case "placeholderFocusScale":

        return true;
      case "placeholderColorString":

        return true;
      case "placeholderColor":

        return true;
      case "placeholderBorderRadius":

        return true;
      case "preloadItemNumber":

        return true;
      case "endHintEnabled":

        return true;
      case "endShakeEnabled":

        return true;
      case "forceBlockFocusOnFail":

        return true;
      case "blockFocusOnFail":

        return true;
      case "enableSelectOnFocus":

        return true;
      case "nextTargetFocusPosition":

        return true;
      case "enableStatesOnFocus":

        return true;
      case "singleSelectPosition":

        return true;
      case "autofocusPosition":

        return true;
      case "autoscrollPosition":

        return true;
      case "autoscroll":

        return true;
      case "list":

        return true;
      case "sharedItemStore":

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
        console.error(`QTFastListView : 未实现propKey : ${propKey}`)
        return true;
      default:
        console.warn(`QTFastFlexView : 未知的未实现propKey : ${propKey}`)
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
      case "useDiff":
      case "keyName":
        console.error(`QTFastListView : 未实现的function : ${method}`)
        return;
    }

    switch (method) {
      case 'scrollToIndex':

        break;
      case 'startScroll':

        break;
      case 'requestChildFocus':

        break;
      case 'setSelectChildPosition':

        break;
      case 'scrollToPositionWithOffset':

        break;
      case 'scrollToPosition':

        break;
      case 'updateItem':

        break;
      case 'updateItemRange':

        break;
      case 'insertItemRange':

        break;
      case 'updateItemMatched':

        break;
      case 'deleteItemRange':

        break;
      case 'setListDataWithParams':

        break;
      case 'addListData':

        break;
      case 'addListDataWithParams':

        break;
      case 'scrollToTop':

        break;
      case 'updateItemProps':

        break;
      case 'scrollToFocus':

        break;
      case 'dispatchItemFunction':

        break;
      case 'clearData':

        break;
      case 'setSpanCount':

        break;
      case 'searchReplaceItem':

        break;
    //with promise
      case 'dispatchItemFunctionWithPromise':

        break;
      case 'getScrollOffset':

        break;
    }
  }
}

@Component
export struct QTFastList {
  @ObjectLink renderView: QTFastListView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  build(): void {
    HRDiv({
      renderView: this.renderView,
      children: this.children
    }).onClick(() => {

    })
  }

  aboutToAppear(): void {

  }
}

