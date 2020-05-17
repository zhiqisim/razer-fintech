import React, { useState, useEffect } from 'react';
import { Button, Container, Card, CardActionArea, Grid, Typography, TextField, makeStyles } from '@material-ui/core';
import { Row, Col } from 'react-bootstrap';
import AddCircleIcon from '@material-ui/icons/AddCircle';
import Popup from "reactjs-popup";
import TopBar from './TopBar';
import NewPromos from './NewPromos';
import SearchBar from '@opuscapita/react-searchbar';
import './storefront.css';
import BGImage from './testbanner/promo2.jpg';

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
  },
  topbar: {
    paddingLeft: 0,
    paddingRight: 0,
    paddingTop: theme.spacing(1)
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
  },
  card1: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    textAlign: 'center',
    paddingLeft: 0,
    paddingRight: 0,
    paddingTop: theme.spacing(0),
    height: 150
  },
  card2: {
    display: 'flex',
    alignItems: 'center',
    paddingRight: theme.spacing(0),
    width: 340,
    height: 120,
    border: '1',
  },
  grid: {
    display: 'flex',
    flexDirection: 'column',
    paddingTop: 50,
    alignItem:'center', 
    justify: 'center',
    textAlign: 'center',
    height: 150
  },
  image: {
    width: 70,
    height: 100
  }, 
  space: {
    paddingTop: theme.spacing(1)
  },
  submit: {
    width: 370
  },
  card: {
    display: 'flex',
    alignItems: 'center',
    paddingRight: theme.spacing(0),
    width: 340,
    height: 120,
    border: '1',
  },
  backgroundBanner: {
    backgroundImage: `url($BGImage)`
  },
  topbarcard: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(2),
  }
}));

export default function StoreFront(props) {
  const styles = useStyles();
  const storeId = props.match.params.appId;
  
  
  // -------------------- STORE DATA ------------------------------------
  const [storeData, setStoreData] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [error, setError] = useState(null);
  
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
  
  // ----------------------------------------------
  
  const [data, setData] = useState(null);
  
  const [allData, setAllData] = useState([]);
  
  const onImageChange = event => {
   if (event.target.files && event.target.files[0]) {
     let reader = new FileReader();
     let file = event.target.files[0];
     reader.onloadend = () => {
       setData({
         ...data,
         imagePreview: reader.result,
         file: file
       });
     };
     reader.readAsDataURL(file);
   }
 };
 
 const submitBannerData = form => {
    form.preventDefault();
    const formData = new FormData();
    formData.append("image", data.file);
  }
  
  // ---------- Image put on hold ---------------------
  
  const addNewItem = () => {
    const newItem = [
      {
        'name': '',
        'price': '',
        'idx': allData.length
      }
    ]
    
    allData.concat(
      newItem
    )
    setAllData(
      [...allData, newItem]
    )
  }
  
  const handleNameChange = (target) => {
    let value = target.target.value;
    let targetid = target.target.id[0]
    for (let i = 0; i < allData.length; ++i){
      if (i == parseInt(targetid)){
        allData[i].name = value;
      }
    }
    setAllData(allData);
  }
  
  const handlePriceChange = (target) => {
    let value = target.target.value;
    let targetid = target.target.id[0]
    for (let i = 0; i < allData.length; ++i){
      if (i == parseInt(targetid)){
        allData[i].price = value;
      }
    }
    setAllData(allData);
  }
  
  const submitNewStore = () => {
    
    let response = {
      'categories': [
        {
          'name': 'shoes',
          'items': [
          ]
        }
      ]
    }
    
    for (let i = 0; i < allData.length; ++i){
      response['categories'][0]['items'].push({
        name: allData[i].name,
        price: allData[i].price
      })
    }
    console.log(response)
    
    fetch(
      'http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/store/' + storeId,
      {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(response)
      },
    ).then(reponse => {
      if (response.status < 600){
        alert('Success! Redirecting to your new store!');
        window.location.href = 'http://localhost:3000/view/' + storeId; 
      }
    }).catch(error => {
      console.log(error);
    });
  }
  
  if (error){
    return <div>Error fetching data</div>;
  } else if (!isLoaded || !storeData){
    return <div>Loading....</div>
  } else {
    console.log(allData);
    return (
      <Container className='containerOverall'>
        <Container className={styles.topbar}>
          <Card className={styles.topbarcard}>
            <TopBar name={storeData.name} address={storeData.location} logo={storeData.logo} />
          </Card>
          {/* New promos */}
          <Card >
            <Popup
              trigger={ 
                <CardActionArea >
                  <Grid className={styles.grid}>
                    <Grid item className={styles.backgroundBanner}>
                      <Typography>
                        Add new Banner
                      </Typography>
                    </Grid>
                    <Grid item>
                      <AddCircleIcon/>
                    </Grid>
                  </Grid>
                </CardActionArea>
            } modal >
              <Typography>
                Choose Banner Image
              </Typography>
              <form onSubmit={form => submitBannerData(form)}>
                <input type='file' name='image' multiple onChange={onImageChange} />
                <div className={styles.space}>
                  <button type='submit'> Upload Image </button>
                </div>
              </form>
            </Popup>
          </Card>
        </Container>
        <Container className={styles.body}>
          <Container className={styles.container}>
            <SearchBar className={styles.searchbar}/>
            {
              allData.map((data, idx) => (
                <Row className={styles.datarow}>
                  <Card className={styles.card}>
                    <CardActionArea className={styles.card}>
                      <Col xs={8}>
                        <TextField id={idx + 'name'} label='Item Name' defaultValue={data.name} onChange={ handleNameChange} />
                        <TextField id={idx + 'price'} label='Price' defaultValue={data.price} onChange={ handlePriceChange } />
                      </Col>
                      <Col>
                        <img src={require("./images/bbt.jpg")} className={styles.image}/>
                      </Col>
                    </CardActionArea>
                  </Card>
                </Row>
              ))
            }
            <Row className={styles.datarow}>
              <Card className={styles.card2} onClick={() => addNewItem()}>
                <CardActionArea className={styles.card2}>
                  <Grid className={styles.grid}>
                    <Grid item>
                      <Typography>
                        Add new Item
                      </Typography>
                    </Grid>
                    <Grid item>
                      <AddCircleIcon/>
                    </Grid>
                  </Grid>
                </CardActionArea>
              </Card>
            </Row>
          </Container>
        </Container>
        
        <div >
          <Button variant='contained' className={styles.submit} onClick={submitNewStore}> Confirm New Store </Button>
        </div>
      </Container>
    );
  }
}