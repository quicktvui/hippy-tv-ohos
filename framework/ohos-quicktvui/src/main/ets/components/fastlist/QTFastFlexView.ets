import {
  HippyRenderBaseView,
  HippyObservedArray,
  HRDiv,
  NativeRenderContext,
  HippyAny,
  HippyRenderCallback
} from 'hippy'


@Observed
export class QTFastFlexView extends HippyRenderBaseView {
  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    switch (propKey) {
      case "cachePool":

        return true;
      case "firstFocusChild":

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
      case "useDiff":
      case "keyName":
        console.error(`QTFastFlexView : 未实现propKey : ${propKey}`)
        return true;
      default:
        console.warn(`QTFastFlexView : 未知的未实现propKey : ${propKey}`)
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
        console.error(`QTFastFlexView : 未实现的function : ${method}`)
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

