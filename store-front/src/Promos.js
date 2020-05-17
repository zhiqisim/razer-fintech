import React from 'react';
import AwesomeSlider from 'react-awesome-slider';
import 'react-awesome-slider/dist/styles.css';
import './promos.css'

export default function Promos() {
  // testing purposes
  const promoBanners = [
    require('./testbanner/promo2.jpg'),
    require('./testbanner/promo1.jpg'),
    require('./testbanner/promo3.jpg') 
  ] 
  
  return (
    <AwesomeSlider className='promos'>
      {promoBanners.map(banner => (
        <div data-src={banner} />
      ))}
    </AwesomeSlider>
  );
}