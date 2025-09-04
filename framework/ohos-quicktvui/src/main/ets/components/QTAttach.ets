import {HippyAny} from 'hippy'
export class QTAttach{
  sid: string | null = null;
  name: string | null = null;
  viewType:string | null = null;
  private extra: Map<string,HippyAny> | null = null;

  putExtra(key:string,value:HippyAny){
    if(!this.extra){
      this.extra = new Map();
    }
    this.extra.set(key,value)
  }

  getExtra(key:string){
    return this.extra == null ? null :  this.extra.get(key);
  }


}
