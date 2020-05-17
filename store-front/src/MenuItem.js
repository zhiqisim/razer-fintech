import React from 'react';
import { Card, Container, CardActionArea, IconButton, Typography, makeStyles } from '@material-ui/core';
import AddShoppingCartIcon from '@material-ui/icons/AddShoppingCart';
import PaymentIcon from '@material-ui/icons/Payment';
import { Row, Col } from 'react-bootstrap';
import Popup from "reactjs-popup";

const useStyles = makeStyles(theme => ({
  card: {
    display: 'flex',
    alignItems: 'center',
    paddingRight: theme.spacing(0),
    width: 340,
    height: 120,
    border: '1',
  },
  image: {
    width: 70,
    height: 100
  },
  purchase: {
    width: 200,
    height: 250,
  },
  purchaseImg: {
    width: 70,
    height: 100
  },
  iconRow: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: theme.spacing(2)
  }
}));

export default function MenuItem(data) {
  const styles = useStyles();
  console.log('MenuItem')
  console.log(data)
  
  function purchaseItem(){
    
  }
  
  return (
    
    <Popup trigger={
      <Card className={styles.card}>
        <CardActionArea className={styles.card}>
          <Col>
            <Typography variant='h6'>
              {data.name}
            </Typography>
            <Typography variant='overline'>
              {data.price}
            </Typography>
          </Col>
          <Col>
            <img src={require("./images/bbt.jpg")} className={styles.image}/>
          </Col>
        </CardActionArea>
      </Card>
    } position="center center">
      <div className={styles.purchase}>
        <Container>
          <img src={require("./images/bbt.jpg")} className={styles.purchaseImg}/>
          <Typography variant='h6'>
            {data.name}
          </Typography>
          <Typography>
            {data.price}
          </Typography>
          <Row className={styles.iconRow}>
            <IconButton color="black" aria-label="add to shopping cart">
              <AddShoppingCartIcon />
            </IconButton>
            <IconButton color="black" aria-label="buy" onClick={purchaseItem}>
              <PaymentIcon />
            </IconButton>
          </Row>
          <Typography>
          </Typography>
        </Container>
      </div>
    </Popup>
  );
}