import {HippyMap} from 'hippy'
export  class HippyUtils{
    static hippyMap2String(map : HippyMap)  {
        let output = '{'
        map.forEach((value,key)=>{
          if(value  instanceof Map){
            output+=  `{${key}:${HippyUtils.hippyMap2String(value)},`
          }else{
            output += `{${key}:${value}},`
          }
        })
        output += '}'
      return output
    }
}

