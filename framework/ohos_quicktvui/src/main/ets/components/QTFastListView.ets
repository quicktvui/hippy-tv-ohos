
import {HippyRenderBaseView,HippyObservedArray,HRDiv,NativeRenderContext,HippyAny,HippyRenderCallback} from 'hippy'


@Observed
export class QTFastListView extends HippyRenderBaseView{

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {
  }

}

@Component
export struct  QTFastList {
  @ObjectLink renderView: QTFastListView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  build(): void {
    HRDiv({
      renderView: this.renderView,
      children:  this.children
    }).onClick(()=>{

    })
  }

  aboutToAppear(): void {

  }
}

