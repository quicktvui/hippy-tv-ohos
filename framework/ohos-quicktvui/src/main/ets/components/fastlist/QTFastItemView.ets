import {
  HippyRenderBaseView,
  HippyObservedArray,
  HRDiv,
  NativeRenderContext,
  HippyAny,
  HippyRenderCallback
} from 'hippy'
import { QTBaseComponentView } from '../QTBaseComponentView';
import { QTDiv, QTDivView } from '../QTDivView';
import QTRenderBaseView from '../QTRenderBaseView';


@Observed
export class QTFastItemView extends QTDivView{

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    switch (propKey) {
      case "focusScrollTarget":

        return true;
      case "firstFocusChild":

        return true;
      case "list":

        return true;
      case "sharedItemStore":

        return true;

    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {

    if (callback) {
      switch (method) {
        case 'dispatchItemFunctionWithPromise':

          break;
      }
    } else {
      switch (method) {
        case 'updateInstance':

          break;
        case 'updateItem':

          break;
        case 'batch':

          break;
        case 'updateItemProps':

          break;
        case 'dispatchItemFunction':

          break;
      }
    }

  }
}
@Reusable
@Component
export struct QTFastItem {
  @ObjectLink renderView: QTFastItemView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  build(): void {
    QTDiv({
      renderView: this.renderView,
      children: this.children
    })
  }

  aboutToAppear(): void {

  }
}

