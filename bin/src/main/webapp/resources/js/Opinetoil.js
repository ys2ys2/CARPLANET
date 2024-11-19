//const API_KEY = 'F241113446'; // 발급받은 API 키
//const API_URL = `http://www.opinet.co.kr/api/avgRecentPrice.do?out=json&code=${API_KEY}`;

// 조회할 제품 코드 설정
//const products = [
 //   { name: "고급휘발유", code: "B034", elementId: "premium-gasoline" },
 //   { name: "보통휘발유", code: "B027", elementId: "regular-gasoline" },
 //   { name: "자동차경유", code: "D047", elementId: "diesel" }
//];

//async function fetchAndDisplayPrices() {
    //for (const product of products) {
       // try {
           // const response = await fetch(`${API_URL}&prodcd=${product.code}`);
          //  const data = await response.json();

            // 데이터 검증 후 가격 표시
     //       if (data.RESULT && data.RESULT.PRICE) {
      //          const priceValue = data.RESULT.PRICE; // 평균 가격
      //          document.getElementById(product.elementId).innerText = `${priceValue} 원`;
        //    } else {
                console.error(`데이터를 찾을 수 없습니다: ${product.name}`);
       //     }
     //   } catch (error) {
            console.error('API 요청 중 오류 발생:', error);
      //  }
   // }
//}

// 데이터 가져오기 및 표시
//fetchAndDisplayPrices();
