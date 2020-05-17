import React from 'react';
import MenuItem from './MenuItem';
import { Container, Grid, makeStyles } from '@material-ui/core';
import { Row, Col } from 'react-bootstrap';
import SearchBar from '@opuscapita/react-searchbar';

const useStyles = makeStyles(theme => ({
  searchbar: {
    border: 'grey',
    paddingBottom: theme.spacing(2)
  },
  datarow: {
    display: 'flex',
    justifyContent: 'center',
    paddingBottom: theme.spacing(2),
    paddingTop: theme.spacing(2)
  },
  datacol: {
    paddingLeft: theme.spacing(2)
  }
}));

function extractData(data){
  const categories = data.categories;
  const extractedData = [];
  
  console.log(data)
  
  for (let categoryId in categories){
    let categoryObj = categories[categoryId];
    let items = categoryObj.items;
    for(let itemId in items){
      let itemObj = items[itemId];
      extractedData.push({
        name: itemObj.name,
        price: itemObj.price
      });
    }
  }
  
  return extractedData;
}

export default function MenuItemList(data) {
  const styles = useStyles();
  
  // Get data for menu
  const extractedData = extractData(data.data);
  
  console.log(extractedData)
  
  return (
    <Container className={styles.container}>
      <SearchBar className={styles.searchbar}/>
      {extractedData.map(data => (
        <Row className={styles.datarow}>
          <MenuItem name={data.name} price={'$' + data.price}/>
        </Row>
      ))}
    </Container>
  );
}