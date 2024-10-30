import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../data/repositories/local_storage_service.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/pdf.dart';
import '../../../providers/get_pdfs_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, String>> pdfList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getPdfsByUserId();
  }

  Future<void> getPdfsByUserId() async {
    setState(() {
      isLoading = true;
    });

    try {
      final getPdfsProvider = Provider.of<GetPdfsProvider>(context, listen: false);
      List<Pdf>? pdfs = await getPdfsProvider.getPdfsByUserId();

      setState(() {
        if (pdfs != null) {
          pdfList = pdfs.map((pdf) => {
            "id": pdf.id.toString(),
            "name": pdf.name,
            "url": pdf.url,
          }).toList();
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildPdfItem({required Map<String, String> pdfData}) {
    return InkWell(
      onTap: () {
        final selectedPdf = Pdf(
          id: int.tryParse(pdfData['id'] ?? '0') ?? 0,
          name: pdfData['name'] ?? '',
          url: pdfData['url'] ?? '',
        );

        Navigator.pushNamed(
          context,
          '/entrypoint',
          arguments: {
            'selectedPdf': selectedPdf,
            'initialIndex': 2
          },
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, size: 30, weight: 700),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Configuracion de la actividad',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(left: 6, bottom: 7),
                    child: Text('Nombre:',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: kPrimaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      pdfData['name'] ?? 'Sin nombre',
                      style: TextStyle(
                          color: kPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Confirmar eliminación',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  '¿Desea eliminar el PDF "${pdfData['name']}"?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xff9A9A9A),
                                    fontFamily: "poppins",
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your delete logic here
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFF3B30),
                                    minimumSize: Size(double.infinity, 48.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Eliminar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      )
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size(double.infinity, 48.h),
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff9A9A9A),
                                      fontFamily: "poppins",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF3B30),
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,// Especifica width y height
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'Eliminar PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125.w,
              height: 125.w,
              decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.insert_drive_file_outlined,
                  size: 100.sp,
                  color: Colors.grey[700]
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                pdfData['name'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Mis PDFs',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8375FD)),
                ),
              ),
            )
          else if (pdfList.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48.sp,
                      color: Color(0xff9A9A9A),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'No tienes ningún PDF guardado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff9A9A9A),
                        fontSize: 14.sp,
                        fontFamily: "poppins",
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.75, // Ajustado para acomodar el texto debajo
                ),
                itemCount: pdfList.length,
                itemBuilder: (context, index) {
                  return _buildPdfItem(pdfData: pdfList[index]);
                },
              ),
            ),
          if (!isLoading && pdfList.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.w),
                  child: Center( // Añade este widget
                    child: Text(
                      'Has llegado al final de los resultados',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: Color(0xff9A9A9A),
                      fontSize: 14.sp,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F8FC),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 190.h,
                  decoration: BoxDecoration(
                    color: kPrimary,
                    image: DecorationImage(
                      image: AssetImage('assets/images/background-top.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mi perfil",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Column(
                    children: [
                      SizedBox(height: 120.h),
                      _buildPdfSection(),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
            Positioned(
              top: 100.h,
              left: 10.w,
              right: 10.w,
              child: _buildProfileSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: (widget.user.profileImg != null &&
                    widget.user.profileImg!.isNotEmpty)
                    ? NetworkImage(widget.user.profileImg!)
                    : AssetImage('assets/images/profile_pic.png') as ImageProvider,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff212121),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/configuration');
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            color: Color(0xffD9D9D9),
            thickness: 1.0,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('1,025', 'puntos\n'),
              Container(
                height: 78.0,
                child: VerticalDivider(
                  color: Color(0xFFD9D9D9),
                  thickness: 1,
                  width: 1,
                ),
              ),
              _buildStatColumn('105', 'actividades\ncompletadas'),
              Container(
                height: 78.0,
                child: VerticalDivider(
                  color: Color(0xFFD9D9D9),
                  thickness: 1,
                  width: 1,
                ),
              ),
              _buildStatColumn('10', 'actividades\ngeneradas'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5B5B5B),
          ),
        ),
      ],
    );
  }
}