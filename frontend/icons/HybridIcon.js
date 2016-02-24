import React from "react"
import {baseColors} from "styles"

export default function HybridIcon({width, height, fillColor}) {
  fillColor = fillColor || baseColors.darkPrimaryColor

  return (
    <svg version="1.1" xmlns="http://www.w3.org/svg/2000" x="0px" y="0px"
      width={`${width}px`} height={`${height}px`} viewBox="0 0 432.074 432.074" fill={fillColor}>
      <g>
        <path d="M201.883,360.072h-27.325c-6.019,0-10.9,4.878-10.9,10.897c0,6.021,4.881,10.899,10.9,10.899h27.325
          c6.02,0,10.9-4.878,10.9-10.899C212.783,364.95,207.902,360.072,201.883,360.072z"/>
        <path d="M299.171,37.684l1.195-13.705c0.243-2.792-0.697-5.559-2.591-7.625
          c-1.894-2.066-4.568-3.243-7.372-3.243h-50.537C236.139,5.354,228.21,0,219.031,0H157.41c-9.179,0-17.108,5.354-20.836,13.11
          H86.037c-2.803,0-5.478,1.177-7.372,3.243c-1.894,2.066-2.834,4.833-2.591,7.625l23.964,274.96c0.002,0.024,0.007,0.047,0.01,0.071
          L88.25,421.112c-0.271,2.807,0.655,5.597,2.55,7.685c1.896,2.087,4.584,3.277,7.403,3.277h180.031c0.007,0,0.013,0,0.02,0
          c5.523,0,10-4.477,10-10c0-0.549-0.044-1.087-0.129-1.611L276.392,299.01c0.002-0.024,0.007-0.047,0.01-0.071l5.616-64.431
          c4.252,0.926,8.602,1.41,13.021,1.41c33.635,0,60.999-27.362,60.999-60.996V98.529C356.037,66.284,330.884,39.818,299.171,37.684z
           M104.209,116.438c1.771,1.517,3.588,3.484,5.782,5.923c6.232,6.925,14.767,16.409,31.009,16.409
          c16.241,0,24.776-9.484,31.008-16.409c5.949-6.609,9.12-9.787,16.142-9.787c7.022,0,10.194,3.178,16.143,9.787
          c6.233,6.925,14.768,16.409,31.012,16.409c16.244,0,24.779-9.484,31.012-16.409c2.253-2.504,4.108-4.513,5.925-6.045
          L257.273,288.07H119.168L104.209,116.438z M279.494,33.11l-5.26,60.358c-11.08,2.518-17.699,9.864-22.782,15.513
          c-5.95,6.61-9.122,9.788-16.146,9.788c-7.025,0-10.196-3.178-16.146-9.788c-6.232-6.925-14.768-16.408-31.009-16.408
          s-24.776,9.484-31.008,16.409c-5.949,6.609-9.12,9.787-16.142,9.787c-7.023,0-10.194-3.178-16.143-9.788
          c-5.064-5.626-11.646-12.94-22.648-15.487L96.947,33.11H279.494z M109.216,412.074l10.049-104.004h137.909l10.048,104.004H109.216z
           M336.037,174.922c0,22.605-18.392,40.996-40.999,40.996c-3.851,0-7.622-0.532-11.264-1.572l13.661-156.742
          c21.495,1.246,38.602,19.123,38.602,40.926V174.922z"/>
      </g>
    </svg>
  )
}
