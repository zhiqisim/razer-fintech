import React, { useState, useEffect } from 'react';
import { Card, Container, Grid, makeStyles } from '@material-ui/core';
import TopBar from './TopBar';
import Promos from './Promos';
import SideBar from './SideBar';
import MenuItemList from './MenuItemList';
import './storefront.css';

const useStyles = makeStyles(theme => ({
  topbar: {
    paddingLeft: 0,
    paddingRight:0,
    paddingTop: theme.spacing(1)
  },
  topbarcard: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(2),
  },
  body: {
    display: 'flex',
    justify: 'space-between',
    paddingTop: theme.spacing(8),
    paddingLeft: theme.spacing(0),
    paddingRight: theme.spacing(0),
  }, 
  sidebar: {
    display: 'flex',
    paddingRight: theme.spacing(1)
  },
  itemlist: {
    width: theme.spacing(9),
    marginLeft: 'auto',
    paddingRight: theme.spacing(0)
  }
}));

export default function StoreFront(props) {
  const styles = useStyles();
  
  const [storeData, setStoreData] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [error, setError] = useState(null);
  
  const storeId =  props.match.params.appId// '-M7QNAMAbaMcBUeal5fj' // 
  
  useEffect(() => {
    fetch(
      'http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/store/' + storeId,
      {
        method: 'GET',
      }
    )
      .then(function(response) {
        if (response.ok){
          return response.json();
        }
        
      })
      .then((data) => {
        setStoreData(data);
        setIsLoaded(true);
      })
      .catch(error => {
        console.log('fail');
        console.log(error);
        setIsLoaded(true);
        setError(error);
      });
  }, []);

  
  if (error){
    return <div>Error fetching data</div>;
  } else if (!isLoaded || !storeData){
    return <div>Loading....</div>
  } else {
    return (
      <Container className='containerOverall'>
        <Container className={styles.topbar}>
          <Card className={styles.topbarcard}>
            <TopBar name={storeData.name} address={storeData.location} logo={storeData.logo}/>
          </Card>
          <Promos/>
        </Container>
        <Container className={styles.body}>
          <MenuItemList data={storeData}/>
        </Container>
      </Container>
    );
  }
}